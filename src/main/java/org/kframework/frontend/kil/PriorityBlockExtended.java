// Copyright (c) 2012-2016 K Team. All Rights Reserved.
package org.kframework.frontend.kil;

import org.kframework.frontend.kil.visitors.Visitor;

import java.util.ArrayList;
import java.util.List;

/** A group within a {@code syntax priorities} declaration.
 * @see PriorityExtended */
public class PriorityBlockExtended extends ASTNode implements Interfaces.MutableList<KLabelConstant, Enum<?>> {

    List<KLabelConstant> productions = new ArrayList<>();

    public List<KLabelConstant> getProductions() {
        return productions;
    }

    public void setProductions(List<KLabelConstant> productions) {
        this.productions = productions;
    }

    public PriorityBlockExtended() {
        super();
    }

    public PriorityBlockExtended(PriorityBlockExtended node) {
        super(node);
        this.productions.addAll(node.productions);
    }

    public PriorityBlockExtended(List<KLabelConstant> productions) {
        super();
        this.productions.addAll(productions);
    }

    @Override
    public String toString() {
        StringBuilder content = new StringBuilder();
        for (KLabelConstant production : productions)
            content.append(production).append(" ");

        if (content.length() > 2)
            content = new StringBuilder(content.substring(0, content.length() - 1));

        return content.toString();
    }

    @Override
    protected <P, R, E extends Throwable> R accept(Visitor<P, R, E> visitor, P p) throws E {
        return visitor.complete(this, visitor.visit(this, p));
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null)
            return false;
        if (this == obj)
            return true;
        if (!(obj instanceof PriorityBlockExtended))
            return false;
        PriorityBlockExtended pb = (PriorityBlockExtended) obj;

        if (pb.productions.size() != productions.size())
            return false;

        for (int i = 0; i < pb.productions.size(); i++) {
            if (!pb.productions.get(i).equals(productions.get(i)))
                return false;
        }

        return true;
    }

    @Override
    public int hashCode() {
        int hash = 0;

        for (KLabelConstant prd : productions)
            hash += prd.hashCode();
        return hash;
    }

    @Override
    public PriorityBlockExtended shallowCopy() {
        return new PriorityBlockExtended(this);
    }

    @Override
    public List<KLabelConstant> getChildren(Enum<?> _void) {
        return productions;
    }

    @Override
    public void setChildren(List<KLabelConstant> children, Enum<?> _void) {
        this.productions = children;
    }

}
