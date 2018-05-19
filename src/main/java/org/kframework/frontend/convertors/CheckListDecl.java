// Copyright (c) 2015-2016 K Team. All Rights Reserved.
package org.kframework.frontend.convertors;

import org.kframework.frontend.kil.*;
import org.kframework.frontend.kil.Module;
import org.kframework.utils.errorsystem.KExceptionManager;

/**
 * Checks user list declarations:
 * - Base sorts cannot be extended with list.
 * - Circular lists are not allowed.
 * - Inline lists are not allowed.
 */
public class CheckListDecl {

    public static void check(Module m) {
        m.getItems().stream().forEach(CheckListDecl::check); // i -> check(i)
    }

    private static void check(ModuleItem i) {
        if (i instanceof Syntax) {
            Syntax s = (Syntax) i;
            for (PriorityBlock b : s.getPriorityBlocks()) {
                for (Production p : b.getProductions()) {
                    if (p.getItems().size() == 1 && p.getItems().get(0) instanceof UserList) { // Syntax Es ::= List{E,""}
                        Sort listSort = s.getDeclaredSort().getSort(); // Es
                        Sort elemSort = ((UserList) p.getItems().get(0)).getSort(); // E
                        if (listSort.equals(elemSort)) {
                            throw KExceptionManager.compilerError("Circular lists are not allowed.", p);
                        }
                    } else {
                        for (ProductionItem it : p.getItems()) {
                            if (it instanceof UserList) { // Syntax Es ::= ... List{E,""} ...
                                throw KExceptionManager.compilerError("Inline list declarations are not allowed.", it);
                            }
                        }
                    }
                }
            }
        }
    }
}
