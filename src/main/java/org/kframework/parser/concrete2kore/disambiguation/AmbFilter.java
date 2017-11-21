// Copyright (c) 2015-2016 K Team. All Rights Reserved.
package org.kframework.parser.concrete2kore.disambiguation;

import com.google.common.collect.Sets;
import org.kframework.treeNodes.*;
import org.kframework.utils.errorsystem.KException;
import org.kframework.utils.errorsystem.KException.ExceptionType;
import org.kframework.utils.errorsystem.KException.KExceptionGroup;
import org.kframework.utils.errorsystem.ParseFailedException;
import scala.Tuple2;
import scala.util.Either;
import scala.util.Right;

import java.util.Set;

/**
 * Eliminate remaining ambiguities by choosing one of them.
 */
public class AmbFilter extends SetsGeneralTransformer<ParseFailedException, ParseFailedException> {

    @Override
    public Tuple2<Either<Set<ParseFailedException>, Term>, Set<ParseFailedException>> apply(Ambiguity amb) {
        Term last = null;
        boolean equal = true;
        Tuple2<Either<Set<ParseFailedException>, Term>, Set<ParseFailedException>> candidate = null;
        for (Term t : amb.items()) {
            candidate = this.apply(t);
            Term next = new RemoveBracketVisitor().apply(candidate._1().right().get());
            if (last != null) {
                if (!last.equals(next)) {
                    equal = false;
                    break;
                }
            }
            last = next;
        }
        if(equal) {
            // all ambiguities have the same abstract syntax, so just pick one
            return candidate;
        }

        StringBuilder msg = new StringBuilder("Parsing ambiguity.");

        for (int i = 0; i < amb.items().size(); i++) {
            msg.append("\n").append(i + 1).append(": ");
            Term elem = (Term) amb.items().toArray()[i];
            if (elem instanceof ProductionReference) {
                ProductionReference tc = (ProductionReference) elem;
                msg.append(tc.production().toString());
            }
            // TODO: use the unparser
            //Unparser unparser = new Unparser(context);
            //msg += "\n   " + unparser.print(elem).replace("\n", "\n   ");
            msg.append("\n    ").append(elem);
        }
        ParseFailedException w = new ParseFailedException(
                new KException(ExceptionType.ERROR, KExceptionGroup.INNER_PARSER, msg.toString(), amb.items().iterator().next().source().orElseGet(null), amb.items().iterator().next().location().orElseGet(null)));

        Tuple2<Either<Set<ParseFailedException>, Term>, Set<ParseFailedException>> rez = this.apply(amb.items().iterator().next());
        return new Tuple2<>(Right.apply(rez._1().right().get()), Sets.union(Sets.newHashSet(w), rez._2()));
    }
}
