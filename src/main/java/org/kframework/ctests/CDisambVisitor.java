// Copyright (c) 2015-2016 K Team. All Rights Reserved.
package org.kframework.ctests;

import com.google.common.collect.Sets;
import org.kframework.treeNodes.*;
import org.kframework.utils.errorsystem.KException;
import org.kframework.utils.errorsystem.ParseFailedException;
import org.kframework.utils.errorsystem.PriorityException;
import scala.util.Either;
import scala.util.Left;
import scala.util.Right;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

/**
 * Disambiguate the C programs according to typedefs.
 */
public class CDisambVisitor extends SetsTransformerWithErrors<ParseFailedException> {

    private Set<String> types = new HashSet<>();
    private boolean inTypedef = false;

    @Override
    public Either<java.util.Set<ParseFailedException>, Term> apply(TermCons tc) {
        assert tc.production() != null : this.getClass() + ":" + " production not found." + tc;
        if (tc.production().klabel().get().equals("CompoundStatement")) {
            Set<String> typesBackup = new HashSet<>(types);
            Either<Set<ParseFailedException>, Term> rez = super.apply(tc);
            types = typesBackup;
            return rez;
        }
        if (tc.production().klabel().get().equals("StructOrUnionDecl")) { // entering a struct decl so temporarily disable inTypedef
            boolean tempInTypedef = inTypedef;
            inTypedef = false;
            Either<Set<ParseFailedException>, Term> rez = super.apply(tc);
            inTypedef = tempInTypedef;
            return rez;
        }
        if (tc.production().klabel().get().equals("FunctionProtoType")) {
            // entering a pointer to function decl so temporarily disable inTypedef for the right child
            boolean tempInTypedef = inTypedef;
            assert tc.items().size() == 2 : "Error. Expected FunctionProtoType to have exactly 2 children.";
            Iterator<Term> it = tc.items().iterator();
            Either<Set<ParseFailedException>, Term> t1 = super.apply(it.next());
            if (t1.isLeft()) return t1;

            inTypedef = false;
            Either<Set<ParseFailedException>, Term> rez = super.apply(tc);
            inTypedef = tempInTypedef;
            return rez;
        }
        if (tc.production().klabel().get().equals("Identifier2DirectDeclarator")) {
            Constant id = (Constant) tc.items().iterator().next();
            if (types.contains(id.value())) { // used as type when it shouldn't
                String msg = id.value() + " is not a typedef.";
                KException kex = new KException(KException.ExceptionType.ERROR, KException.KExceptionGroup.CRITICAL, msg, tc.source().get(), tc.location().get());
                return Left.apply(Sets.newHashSet(new PriorityException(kex)));
            } else if (inTypedef) // new type decl
                types.add(id.value());
        }
        if (tc.production().klabel().get().equals("Identifier2TypedefName")) {
            Constant id = (Constant) tc.items().iterator().next();
            if (!types.contains(id.value())) {  // name used as a type decl
                String msg = id.value() + " is not a typedef.";
                KException kex = new KException(KException.ExceptionType.ERROR, KException.KExceptionGroup.CRITICAL, msg, tc.source().get(), tc.location().get());
                return Left.apply(Sets.newHashSet(new PriorityException(kex)));
            }
        }
        if (tc.production().klabel().get().equals("Identifier2PrimaryExpression")) {
            Constant id = (Constant) tc.items().iterator().next();
            if (types.contains(id.value())) {  // type used as new type decl
                String msg = id.value() + " is a typedef.";
                KException kex = new KException(KException.ExceptionType.ERROR, KException.KExceptionGroup.CRITICAL, msg, tc.source().get(), tc.location().get());
                return Left.apply(Sets.newHashSet(new PriorityException(kex)));
            }
        }
        if (tc.production().klabel().get().equals("typedef"))
            inTypedef = true;
        if (tc.production().klabel().get().equals("Declaration")) {
            Either<Set<ParseFailedException>, Term> rez = super.apply(tc);
            inTypedef = false;
            return rez;
        }
        return super.apply(tc);
    }

    public Either<java.util.Set<ParseFailedException>, Term> apply(Ambiguity amb) {
        Set<String> typesback = new HashSet<>(types);
        Iterator<Term> it = amb.items().iterator();

        Either<Set<ParseFailedException>, Term> t1 = super.apply(it.next());
        assert amb.items().size() == 2 : "Error in grammar, expected 2 ambiguities: " + t1.right().get().source() + ":" + t1.right().get().location();;
        Set<String> typesT1 = types;
        types = typesback;
        Either<Set<ParseFailedException>, Term> t2 = super.apply(it.next());
        if (t1.isLeft()) {
            return t2;
        } else {
            assert t2.isLeft() : "Could not disambiguate: " + t2.right().get().source() + ":" + t2.right().get().location();
            types = typesT1;
            return t1;
        }
    }
}
