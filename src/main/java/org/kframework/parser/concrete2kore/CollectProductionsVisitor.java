// Copyright (c) 2014-2016 K Team. All Rights Reserved.
package org.kframework.parser.concrete2kore;

import org.kframework.frontend.kil.Module;
import org.kframework.frontend.kil.Production;
import org.kframework.frontend.kil.Syntax;
import org.kframework.frontend.kil.loader.Context;
import org.kframework.frontend.kil.visitors.BasicVisitor;

public class CollectProductionsVisitor extends BasicVisitor {
    private String moduleName;

    public CollectProductionsVisitor(Context context) {
        super(context);
    }


    @Override
    public Void visit(Module mod, Void _void) {
        this.moduleName = mod.getName();
        super.visit(mod, _void);
        return null;
    }

    @Override
    public Void visit(Production node, Void _void) {
        context.addProduction(node);
        node.setOwnerModuleName(moduleName);
        this.getCurrentModule().getModuleContext().addProduction(node);
        return null;
    }
}
