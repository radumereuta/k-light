// Copyright (c) 2015-2016 K Team. All Rights Reserved.
package org.kframework.parser.concrete2kore.generator;

import org.kframework.attributes.Att;
import org.kframework.frontend.ADT;
import org.kframework.utils.Collections;
import org.kframework.definition.*;
import org.kframework.frontend.kil.loader.Constants;
import org.kframework.parser.concrete2kore.ParseInModule;
import org.kframework.utils.UserList;

import java.util.Set;
import java.util.stream.Collectors;

import static org.kframework.utils.Collections.*;
import static org.kframework.definition.Constructors.NonTerminal;
import static org.kframework.definition.Constructors.SyntaxSort;
import static org.kframework.definition.Constructors.Sort;


/**
 * Generator for rule and ground parsers.
 * Takes as input a reference to a definition containing all the base syntax of K
 * and uses it to generate a grammar by connecting all users sorts in a lattice with
 * the top sort KItem#Top and the bottom sort KItem#Bottom.
 * <p>
 * The instances of the non-terminal KItem is renamed in KItem#Top if found in the right
 * hand side of a production, and into KItem#Bottom if found in the left hand side.
 */
public class RuleGrammarGenerator {
    /**
     * Creates the seed module that can be used to parse programs.
     * Imports module markers PROGRAM-LISTS found in /include/kast.k.
     *
     * @param mod The user defined module from which to start.
     * @return a new module which imports the original user module and a set of marker modules.
     */
    public static Module getProgramsGrammar(Module mod, Definition baseK) {
        assert baseK.modules().contains(mod);

        return mod;
    }

    /**
     * Create the rule org.kframework.parser for the given module.
     * It creates a module which includes the given module and the base K module given to the
     * constructor. The new module contains syntax declaration for Casts and the diamond
     * which connects the user concrete syntax with K syntax.
     *
     * @param seedMod module for which to create the org.kframework.parser.
     * @return org.kframework.parser which applies disambiguation filters by default.
     */
    public static ParseInModule getCombinedGrammar(Module seedMod) {
        Module extensionM = getExtensionModule(seedMod);
        Module disambM = genDisambModule(extensionM);
        Module parseM = genParserModule(disambM);
        return new ParseInModule(seedMod, extensionM, disambM, parseM);
    }

    private static Module getExtensionModule(Module seedMod) { /* Extension module is used by the compiler to get information about subsorts and access the definition of casts */
        return ModuleTransformer.fromHybrid((Module m) -> {
            return m;
        }, "Generate Extension module").apply(seedMod);
    }

    private static Module genParserModule(Module disambM) { /* Parsing module is used to generate the grammar for the kernel of the org.kframework.parser. */
        return (new HybridMemoizingModuleTransformer() {

            @Override
            public Module processHybridModule(Module m) {
                Set<Sentence> newProds = mutable(m.localSentences());
                java.util.List<UserList> uLists = UserList.getLists(newProds);
                // eliminate the general list productions
                newProds = newProds.stream().filter(p -> !(p instanceof Production && p.att().contains(Att.userList()))).collect(Collectors.toSet());
                // for each triple, generate a new pattern which works better for parsing lists in programs.
                for (UserList ul : uLists) {
                    Production prod1, prod2, prod3, prod4, prod5;

                    Att newAtts = ul.attrs.remove("userList");
                    // TODO: find a way to pass on the original production to the parser
                    // Es#Terminator ::= "" [klabel('.Es)]
                    prod1 = Constructors.Production(ul.terminatorKLabel,
                            Sort(ul.sort.localName() + "#Terminator"),
                            Collections.Seq(Constructors.Terminal("")),
                            newAtts.add("klabel", ul.terminatorKLabel).add(Constants.ORIGINAL_PRD, ul.pTerminator.toString()));
                    // Ne#Es ::= E "," Ne#Es [klabel('_,_)]
                    prod2 = Constructors.Production(ul.klabel, Sort("Ne#" + ul.sort.localName()),
                            Collections.Seq(NonTerminal(ul.childSort), Constructors.Terminal(ul.separator), NonTerminal(Sort("Ne#" + ul.sort.localName()))),
                            newAtts.add("klabel", ul.klabel).add(Constants.ORIGINAL_PRD, ul.pList.toString()));
                    // Ne#Es ::= E Es#Terminator [klabel('_,_)]
                    prod3 = Constructors.Production(ul.klabel, Sort("Ne#" + ul.sort.localName()),
                            Collections.Seq(NonTerminal(ul.childSort), NonTerminal(Sort(ul.sort.localName() + "#Terminator"))),
                            newAtts.add("klabel", ul.klabel).add(Constants.ORIGINAL_PRD, ul.pList.toString()));
                    // Es ::= Ne#Es
                    prod4 = Constructors.Production(ul.sort, Collections.Seq(NonTerminal(Sort("Ne#" + ul.sort.localName()))));
                    // Es ::= Es#Terminator // if the list is *
                    prod5 = Constructors.Production(ul.sort, Collections.Seq(NonTerminal(Sort(ul.sort.localName() + "#Terminator"))));

                    newProds.add(prod1);
                    newProds.add(prod2);
                    newProds.add(prod3);
                    newProds.add(prod4);
                    newProds.add(SyntaxSort(Sort(ul.sort.localName() + "#Terminator")));
                    newProds.add(SyntaxSort(Sort("Ne#" + ul.sort.localName())));
                    if (!ul.nonEmpty) {
                        newProds.add(prod5);
                    }
                }

                return Constructors.Module(m.name(), m.imports(), immutable(newProds), m.att());
            }
        }).apply(disambM);
    }

    private static Module genDisambModule(Module extensionM) {
        // Disambiguation module is used by the org.kframework.parser to have an easier way of disambiguating parse trees.
        return (new HybridMemoizingModuleTransformer() {

            @Override
            public Module processHybridModule(Module m) {
                return m;
            }
        }).apply(extensionM);
    }
}
