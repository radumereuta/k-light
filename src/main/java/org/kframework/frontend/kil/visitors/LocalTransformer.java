// Copyright (c) 2014-2016 K Team. All Rights Reserved.
package org.kframework.frontend.kil.visitors;

import org.kframework.frontend.kil.ASTNode;
import org.kframework.frontend.kil.loader.Context;
import org.kframework.utils.errorsystem.ParseFailedException;

/**
 * A {@link AbstractTransformer} which doesn't visit its children. See also
 * {@link org.kframework.backend.java.symbolic.LocalTransformer}.
 * @author dwightguth
 *
 */
public class LocalTransformer extends AbstractTransformer<ParseFailedException> {

    public LocalTransformer(String name, Context context) {
        super(name, context);
    }

    @Override
    public boolean visitChildren() {
        return false;
    }

    @Override
    public <T extends ASTNode> T copy(T original) {
        return original;
    }
}
