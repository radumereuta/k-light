// Copyright (c) 2014-2016 K Team. All Rights Reserved.
package org.kframework.frontend.kil;

import org.kframework.frontend.kil.loader.Context;
import org.kframework.frontend.kil.visitors.Visitor;

import java.util.*;
import java.util.Collection;

/**
 * A builtin set
 *
 * @author TraianSF
 */
public class SetBuiltin extends CollectionBuiltin {
    public SetBuiltin(DataStructureSort sort, Collection<Term> baseTerms, Collection<Term> elements) {
        super(sort, baseTerms, elements);
    }

    @Override
    protected <P, R, E extends Throwable> R accept(Visitor<P, R, E> visitor, P p) throws E {
        return visitor.complete(this, visitor.visit(this, p));
    }

    @Override
    public DataStructureBuiltin shallowCopy(Collection<Term> baseTerms) {
        return new SetBuiltin(sort(), baseTerms, elements());
    }

    @Override
    public CollectionBuiltin shallowCopy(Collection<Term> baseTerms,
                                         Collection<Term> elements) {
        return new SetBuiltin(sort(), baseTerms, elements);
    }

    @Override
    public Term toKApp(Context context, Comparator<Term> comparator) {
        List<Term> items = new ArrayList<>();
        for (Term element : elements()) {
            Term item = KApp.of(element.getLocation(), element.getSource(), sort().elementLabel(), element);
            items.add(item);
        }
        for (Term base : baseTerms()) {
            items.add(base);
        }
        Collections.sort(items, comparator);
        return toKApp(items);
    }
}
