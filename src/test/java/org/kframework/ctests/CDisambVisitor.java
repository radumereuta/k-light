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

    @Override
    public Either<java.util.Set<ParseFailedException>, Term> apply(TermCons tc) {
        assert tc.production() != null : this.getClass() + ":" + " production not found." + tc;
        if (tc.production().klabel().get().equals("CompoundStatement")) {
            Set<String> typesBackup = new HashSet<>(types);
            Either<Set<ParseFailedException>, Term> rez = super.apply(tc);
            types = typesBackup;
            return rez;
        }
        return super.apply(tc);
    }

    public Either<java.util.Set<ParseFailedException>, Term> apply(Ambiguity amb) {
        Either<Set<ParseFailedException>, Term> rez = new CEliminateVisitor().apply(amb);
        if (rez.isLeft()) return rez;
        new CCollectVisitor().apply(rez.right().get());

        return super.apply(rez.right().get());
    }

    private class CEliminateVisitor extends SetsTransformerWithErrors<ParseFailedException> {
        @Override
        public Either<java.util.Set<ParseFailedException>, Term> apply(TermCons tc) {
            assert tc.production() != null : this.getClass() + ":" + " production not found." + tc;
            if (tc.production().klabel().get().equals("Identifier2TypedefName")) {
                Constant id = (Constant) tc.items().iterator().next();
                if (!types.contains(id.value())) {
                    String msg = id.value() + " is not a type.";
                    KException kex = new KException(KException.ExceptionType.ERROR, KException.KExceptionGroup.CRITICAL, msg, tc.source().get(), tc.location().get());
                    return Left.apply(Sets.newHashSet(new PriorityException(kex)));
                }
            }
            if (tc.production().klabel().get().equals("Identifier2PrimaryExpression")) {
                Constant id = (Constant) tc.items().iterator().next();
                if (types.contains(id.value())) {
                    String msg = id.value() + " is a type.";
                    KException kex = new KException(KException.ExceptionType.ERROR, KException.KExceptionGroup.CRITICAL, msg, tc.source().get(), tc.location().get());
                    return Left.apply(Sets.newHashSet(new PriorityException(kex)));
                }
            }
            return super.apply(tc);
        }
    }

    private class CCollectVisitor extends SafeTransformer {
        @Override
        public Term apply(TermCons tc) {
            assert tc.production() != null : this.getClass() + ":" + " production not found." + tc;
            if (tc.production().klabel().get().equals("Identifier2DirectDeclarator")) {
                Constant id = (Constant) tc.items().iterator().next();
                types.add(id.value());
            }

            return super.apply(tc);
        }
    }
}
