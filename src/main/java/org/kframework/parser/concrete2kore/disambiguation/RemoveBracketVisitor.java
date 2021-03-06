// Copyright (c) 2014-2016 K Team. All Rights Reserved.
package org.kframework.parser.concrete2kore.disambiguation;

import org.kframework.treeNodes.SafeTransformer;
import org.kframework.treeNodes.Term;
import org.kframework.treeNodes.TermCons;

public class RemoveBracketVisitor extends SafeTransformer {
    @Override
    public Term apply(TermCons tc) {
        if (tc.production().att().contains("bracket")) {
            return apply(tc.get(0));
        }
        return super.apply(tc);
    }
}
