// Copyright (c) 2014-2016 K Team. All Rights Reserved.
package org.kframework.frontend.kil.visitors;

import org.kframework.frontend.kil.ASTNode;
import org.kframework.frontend.kil.AbstractVisitor;
import org.kframework.frontend.kil.Definition;
import org.kframework.frontend.kil.Module;
import org.kframework.frontend.kil.loader.Context;

/**
 * A helper class designed to encapsulate functionality shared between
 * {@link LocalTransformer}, {@link ParseForestTransformer}, and {@link CopyOnWriteTransformer}.
 *
 * This class serves to replace the Transformable interface that existed before, and implements
 * functionality specific to visitors which transform terms.
 * @author dwightguth
 *
 */
public abstract class AbstractTransformer<E extends Throwable> extends AbstractVisitor<Void, ASTNode, E> {

    public AbstractTransformer(String name, Context context) {
        super(name, context);
    }

    public AbstractTransformer(String name, Context context,
                               Definition currentDefinition, Module currentModule) {
        super(name, context, currentDefinition, currentModule);
    }

    @Override
    public ASTNode defaultReturnValue(ASTNode node, Void _void) {
        return node;
    }

    @SuppressWarnings("unchecked")
    @Override
    public <T extends ASTNode> T processChildTerm(T child, ASTNode childResult) {
        return (T)childResult;
    }

    @Override
    public boolean cache() {
        return false;
    }

    @Override
    public <T extends ASTNode> boolean changed(T o, T n) {
        return o != n;
    }

}
