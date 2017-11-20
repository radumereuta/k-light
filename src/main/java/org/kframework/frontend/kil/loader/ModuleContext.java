// Copyright (c) 2014-2016 K Team. All Rights Reserved.
package org.kframework.frontend.kil.loader;

import com.google.common.collect.HashMultimap;
import com.google.common.collect.SetMultimap;
import org.kframework.frontend.kil.*;

import java.io.Serializable;
import java.util.*;

public class ModuleContext implements Serializable {
    /** set of imported modules into this module. Should contain the auto included ones */
    private Set<Module> importedModules = new HashSet<>();
    /** declared sorts visible in this module (transitive) */
    private Set<Sort> declaredSorts = new HashSet<>();
    /** multimap from a klabel to a production visible in this m/odule (transitive) */
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
        if (p.getKLabel() != null) {
            klabels.put(p.getKLabel(), p);
            tags.put(p.getKLabel(), p);
            if (p.isListDecl()) {
                listKLabels.put(p.getTerminatorKLabel(), p);
            }
        }
        if (p.isListDecl()) {
            listProductions.put(p.getSort(), p);
        }
        for (Attribute<?> a : p.getAttributes().values()) {
            tags.put(a.getKey().toString(), p);
        }
    }
}
