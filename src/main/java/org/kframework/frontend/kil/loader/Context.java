// Copyright (c) 2014-2016 K Team. All Rights Reserved.
package org.kframework.frontend.kil.loader;

import com.google.common.collect.*;
import org.kframework.frontend.kil.*;

import java.io.Serializable;
import java.util.*;

public class Context implements Serializable {

    /**
     * Represents the bijection map between conses and productions.
     */
    public Set<Production> productions = new HashSet<>();
    /**
     * Represents a map from all Klabels in string representation
     * to sets of corresponding productions.
     * why?
     */
    public SetMultimap<String, Production> klabels = HashMultimap.create();
    public SetMultimap<String, Production> tags = HashMultimap.create();
    public Map<Sort, Production> listProductions = new LinkedHashMap<>();
    public SetMultimap<String, Production> listKLabels = HashMultimap.create();

    private BiMap<String, Production> conses;

    public Context() {
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
