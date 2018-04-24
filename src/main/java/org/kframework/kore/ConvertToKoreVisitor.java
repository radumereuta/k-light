// Copyright (c) 2014-2016 K Team. All Rights Reserved.
package org.kframework.kore;

import org.kframework.treeNodes.*;
import org.kframework.utils.StringUtil;

import java.util.ArrayList;
import java.util.Collections;

/**
 * Apply a transformer from TermCons to the new KORE textual format.
 */
public class ConvertToKoreVisitor extends SafeTransformer {

    public StringBuilder sb = new StringBuilder();
    @Override
    public Term apply(Ambiguity amb) {
        sb.append("\\or{}");
        sb.append("(");
        java.util.Iterator<Term> terms = amb.items().iterator();
        while (terms.hasNext()) {
            Term t = terms.next();
            this.apply(t);
            if (terms.hasNext())
                sb.append(",");
        }
        sb.append(")");

        return amb;
    }

    @Override
    public Term apply(TermCons tc) {
        sb.append(tc.production().klabel().get());
        sb.append("{}");
        sb.append("(");
        ArrayList<Term> temp = new ArrayList(tc.items());
        Collections.reverse(temp);
        java.util.Iterator<Term> terms = temp.iterator();
        while (terms.hasNext()) {
            Term t = terms.next();
            this.apply(t);
            if (terms.hasNext())
                sb.append(",");
        }
        sb.append(")");

        return tc;
    }

    @Override
    public Term apply(Constant cst) {
        sb.append("\\dv{");
        sb.append(cst.production().sort().localName());
        sb.append("}(");
        sb.append(StringUtil.enquoteCString(cst.value()));
        sb.append(")");
        return cst;
    }
}
