// Copyright (c) 2014-2016 K Team. All Rights Reserved.
package org.kframework.frontend.kil.loader;

import com.google.common.collect.HashMultimap;
import com.google.common.collect.SetMultimap;
import org.kframework.frontend.kil.Attribute;
import org.kframework.frontend.kil.Module;
import org.kframework.frontend.kil.Production;
import org.kframework.frontend.kil.Sort;

import java.io.Serializable;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

public class ModuleContext implements Serializable {
    /** set of imported modules into this module. Should contain the auto included ones */
    private Set<Module> importedModules = new HashSet<>();
    /** declared sorts visible in this module (transitive) */
    private Set<Sort> declaredSorts = new HashSet<>();
    /** multimap from a symbol to a production visible in this m/odule (transitive) */
    public SetMultimap<String, Production> klabels = HashMultimap.create();
    /** multimap from a tag to a production visible in this module (transitive) */
    public SetMultimap<String, Production> tags = HashMultimap.create();

    /**
     * Represents the bijection map between conses and productions.
     */
    public Set<Production> productions = new HashSet<>();
    public Map<Sort, Production> listProductions = new LinkedHashMap<>();
    public SetMultimap<String, Production> listKLabels = HashMultimap.create();

    public void add(ModuleContext moduleContext) {
        this.importedModules.addAll(moduleContext.importedModules);
        this.declaredSorts.addAll(moduleContext.declaredSorts);
        this.klabels.putAll(moduleContext.klabels);
        this.tags.putAll(moduleContext.tags);
    }

    public void addProduction(Production p) {
        productions.add(p);
        if (p.getSymbol() != null) {
            klabels.put(p.getSymbol(), p);
            tags.put(p.getSymbol(), p);
        }
        if (p.isListDecl()) {
            listProductions.put(p.getSort(), p);
        }
        for (Attribute a : p.getAttributes().values()) {
            tags.put(a.getKey(), p);
        }
    }
}
