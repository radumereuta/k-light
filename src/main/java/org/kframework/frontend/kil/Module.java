// Copyright (c) 2012-2016 K Team. All Rights Reserved.
package org.kframework.frontend.kil;

import org.kframework.frontend.kil.loader.ModuleContext;
import org.kframework.frontend.kil.visitors.Visitor;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Set;

/** A module. */
public class Module extends DefinitionItem implements Interfaces.MutableList<ModuleItem, Enum<?>> {
    private String name;
    private List<ModuleItem> items = new ArrayList<>();

    // keeps easy to access information about the current module
    private transient ModuleContext moduleContext = new ModuleContext();

    // lazily computed set of sorts.
    private Set<Sort> sorts;

    public Module(Module m) {
        super(m);
        this.name = m.name;
        this.items = m.items;
        this.sorts = m.sorts;
    }

    public Module() {
        super();
    }

    public Module(String name) {
        super();
        this.name = name;
    }

    public void appendModuleItem(ModuleItem item) {
        this.items.add(item);
        this.sorts = null;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setItems(List<ModuleItem> items) {
        this.items = items;
        this.sorts = null;
    }

    public List<ModuleItem> getItems() {
        return items;
    }

    @Override
    public String toString() {
        String content = "";
        List<ModuleItem> sortedItems = new ArrayList<>(items);

        sortedItems.sort(new Comparator<ModuleItem>() {
            @Override
            public int compare(ModuleItem o1, ModuleItem o2) {
                return o1.toString().compareTo(o2.toString());
            }
        });

        for (ModuleItem i : sortedItems)
            content += i + " \n";

        return "module " + name + "\n" + content + "\nendmodule";
    }

    @Override
    protected <P, R, E extends Throwable> R accept(Visitor<P, R, E> visitor, P p) throws E {
        return visitor.complete(this, visitor.visit(this, p));
    }

    public Module addModuleItems(List<ModuleItem> rules) {
        Module result = new Module(this);
        List<ModuleItem> items = new ArrayList<>(this.items);
        items.addAll(rules);
        this.sorts = null;
        result.setItems(items);
        return result;
    }

    @Override
    public Module shallowCopy() {
        return new Module(this);
    }

    @Override
    public List<ModuleItem> getChildren(Enum<?> _void) {
        return items;
    }

    @Override
    public void setChildren(List<ModuleItem> children, Enum<?> _void) {
        this.items = children;
        this.sorts = null;
    }

    public ModuleContext getModuleContext() {
        return moduleContext;
    }

}
