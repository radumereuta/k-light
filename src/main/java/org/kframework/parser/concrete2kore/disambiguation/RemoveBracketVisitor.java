// Copyright (c) 2014-2016 K Team. All Rights Reserved.
package org.kframework.parser.concrete2kore.disambiguation;

import org.kframework.treeNodes.Ambiguity;
import org.kframework.treeNodes.SafeTransformer;
import org.kframework.treeNodes.Term;
import org.kframework.treeNodes.TermCons;

import java.util.HashSet;
import java.util.Set;

public class RemoveBracketVisitor extends SafeTransformer {
    @Override
    public Term apply(TermCons tc) {
        if (tc.production().att().contains("bracket")) {
            return apply(tc.get(0));
        }
        return super.apply(tc);
    }

    // workaround: I would have expected SafeTransformer to eliminate ambiguities with only one node, but apparently it doesn't
    @Override
    public Term apply(Ambiguity amb) {
        Set<Term> trms = new HashSet<>();
        for (Term t:amb.items()) {
            trms.add(super.apply(t));
        }

        if (trms.size() == 1) {
            return trms.iterator().next();
        }
        return super.apply(amb);
    }
}
