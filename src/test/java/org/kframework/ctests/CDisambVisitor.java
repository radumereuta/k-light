// Copyright (c) 2015-2016 K Team. All Rights Reserved.
package org.kframework.ctests;

import com.google.common.collect.Sets;
import org.kframework.treeNodes.*;
import org.kframework.utils.errorsystem.KException;
import org.kframework.utils.errorsystem.ParseFailedException;
import org.kframework.utils.errorsystem.PriorityException;
import scala.util.Either;
import scala.util.Left;

import java.util.HashSet;
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
        if (tc.production().klabel().get().equals("Identifier2DirectDeclarator") && inTypedef) {
            Constant id = (Constant) tc.items().iterator().next();
            if (types.contains(id.value())) { // used as type when it shouldn't
                String msg = id.value() + " is not a type.";
                KException kex = new KException(KException.ExceptionType.ERROR, KException.KExceptionGroup.CRITICAL, msg, tc.source().get(), tc.location().get());
                return Left.apply(Sets.newHashSet(new PriorityException(kex)));
            } else
                types.add(id.value()); // new type decl
        }
        if (tc.production().klabel().get().equals("Identifier2TypedefName")) {
            Constant id = (Constant) tc.items().iterator().next();
            if (!types.contains(id.value())) {  // name used as a type decl
                String msg = id.value() + " is not a type.";
                KException kex = new KException(KException.ExceptionType.ERROR, KException.KExceptionGroup.CRITICAL, msg, tc.source().get(), tc.location().get());
                return Left.apply(Sets.newHashSet(new PriorityException(kex)));
            }
        }
        if (tc.production().klabel().get().equals("Identifier2PrimaryExpression")) {
            Constant id = (Constant) tc.items().iterator().next();
            if (types.contains(id.value())) {  // type used as new type decl
                String msg = id.value() + " is a type.";
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
        Either<Set<ParseFailedException>, Term> rez = null;
        Set<String> typesfwd = new HashSet<>(types);
        Set<String> typesback = null;

        for (Term i : amb.items()) {
            Either<Set<ParseFailedException>, Term> temp = super.apply(i);
            if (temp.isRight()) {
                assert typesback == null;
                typesback = types;
                rez = temp;
            }
            types = typesfwd;
        }
        assert typesback != null;
        types = typesback;

        return rez;
    }
}
