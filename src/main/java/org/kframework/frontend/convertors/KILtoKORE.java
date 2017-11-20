// Copyright (c) 2014-2016 K Team. All Rights Reserved.

package org.kframework.frontend.convertors;

import com.google.common.collect.Sets;
import org.kframework.attributes.Att;
import org.kframework.definition.*;
import org.kframework.definition.ProductionItem;
import org.kframework.frontend.ADT;
import org.kframework.frontend.kil.*;
import org.kframework.frontend.kil.Definition;
import org.kframework.frontend.kil.Module;
import org.kframework.frontend.kil.NonTerminal;
import org.kframework.frontend.kil.Production;
import org.kframework.frontend.kil.Terminal;
import org.kframework.utils.errorsystem.KEMException;
import org.kframework.utils.errorsystem.KExceptionManager;
import scala.Enumeration.Value;
import scala.collection.Seq;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static org.kframework.utils.Collections.*;
import static org.kframework.definition.Constructors.*;

public class KILtoKORE extends KILTransformation<Object> {

    private org.kframework.frontend.kil.loader.Context context;
    private KILtoInnerKORE inner;
    private final boolean syntactic;

    public KILtoKORE(org.kframework.frontend.kil.loader.Context context, boolean syntactic) {
        this.context = context;
        inner = new KILtoInnerKORE(context);
        this.syntactic = syntactic;
    }

    public KILtoKORE(org.kframework.frontend.kil.loader.Context context) {
        this.context = context;
        inner = new KILtoInnerKORE(context);
        this.syntactic = false;
    }

    public org.kframework.definition.Definition apply(Definition d) {
//        Set<org.kframework.definition.Require> requires = d.getItems().stream()
//                .filter(i -> i instanceof Require).map(i -> apply((Require) i))
//                .collect(Collectors.toSet());

        Set<Module> kilModules = d.getItems().stream().filter(i -> i instanceof Module)
                .map(mod -> (Module) mod).collect(Collectors.toSet());

        Module mainModule = kilModules.stream()
                .filter(mod -> mod.getName().equals(d.getMainModule())).findFirst().get();

        HashMap<String, org.kframework.definition.Module> koreModules = new HashMap<>();
        apply(mainModule, kilModules, koreModules);

        // Set<org.kframework.definition.Module> modules = kilModules.map(i ->
        // apply((Module) i))
        // .collect(Collectors.toSet());

        // TODO: handle LiterateDefinitionComments

        return Definition(
                koreModules.get(mainModule.getName()),
                immutable(new HashSet<>(koreModules.values())), Constructors.Att());
    }

    public org.kframework.definition.Module apply(Module mainModule, Set<Module> allKilModules,
                                                  Map<String, org.kframework.definition.Module> koreModules) {
        return apply(mainModule, allKilModules, koreModules, Seq());
    }

    private org.kframework.definition.Module apply(Module mainModule, Set<Module> allKilModules,
                                                   Map<String, org.kframework.definition.Module> koreModules,
                                                   scala.collection.Seq<Module> visitedModules) {
        checkCircularModuleImports(mainModule, visitedModules);
        CheckListDecl.check(mainModule);
        Set<org.kframework.definition.Sentence> items = mainModule.getItems().stream()
                .filter(j -> !(j instanceof org.kframework.frontend.kil.Import))
                .flatMap(j -> apply(j).stream()).collect(Collectors.toSet());

        Set<Import> importedModuleNames = mainModule.getItems().stream()
                .filter(imp -> imp instanceof Import)
                .map(imp -> (Import) imp)
                .collect(Collectors.toSet());

        Set<org.kframework.definition.Module> importedModules = importedModuleNames.stream()
                .map(imp -> {
                    Optional<Module> theModule = allKilModules.stream()
                            .filter(m -> m.getName().equals(imp.getName()))
                            .findFirst();
                    if (theModule.isPresent()) {
                        Module mod = theModule.get();
                        org.kframework.definition.Module result = koreModules.get(mod.getName());
                        if (result == null) {
                            result = apply(mod, allKilModules, koreModules, cons(mainModule, visitedModules));
                        }
                        return result;
                    } else if (koreModules.containsKey(imp.getName())) {
                        return koreModules.get(imp.getName());
                    } else
                        throw KExceptionManager.compilerError("Could not find module: " + imp.getName(), imp);
                }).collect(Collectors.toSet());


        org.kframework.definition.Module newModule = Constructors.Module(mainModule.getName(), immutable(importedModules), immutable(items),
                inner.convertAttributes(mainModule));
        koreModules.put(newModule.name(), newModule);
        return newModule;
    }

    private static void checkCircularModuleImports(Module mainModule, scala.collection.Seq<Module> visitedModules) {
        if (visitedModules.contains(mainModule)) {
            String msg = "Found circularity in module imports: ";
            for (Module m : mutable(visitedModules)) { // JavaConversions.seqAsJavaList(visitedModules)
                msg += m.getName() + " < ";
            }
            msg += visitedModules.head().getName();
            throw KEMException.compilerError(msg);
        }
    }

    @SuppressWarnings("unchecked")
    public Set<org.kframework.definition.Sentence> apply(ModuleItem i) {
        if (i instanceof Syntax || i instanceof PriorityExtended) {
            return (Set<org.kframework.definition.Sentence>) apply((ASTNode) i);
        } else {
            return Sets.newHashSet((org.kframework.definition.Sentence) apply((ASTNode) i));
        }
    }

    public org.kframework.definition.Bubble apply(StringSentence sentence) {
        return Bubble(sentence.getType(), sentence.getContent(), inner.convertAttributes(sentence)
                .add("contentStartLine", "" + sentence.getContentStartLine())
                .add("contentStartColumn", "" + sentence.getContentStartColumn()));
    }

    public ModuleComment apply(LiterateModuleComment m) {
        return new org.kframework.definition.ModuleComment(m.getValue(),
                inner.convertAttributes(m));
    }

    public org.kframework.definition.SyntaxAssociativity apply(PriorityExtendedAssoc ii) {
        scala.collection.Set<Tag> tags = toTags(ii.getTags());
        String assocOrig = ii.getAssoc();
        Value assoc = applyAssoc(assocOrig);
        return SyntaxAssociativity(assoc, tags);
    }

    public Value applyAssoc(String assocOrig) {
        // "left", "right", "non-assoc"
        switch (assocOrig) {
        case "left":
            return Associativity.Left();
        case "right":
            return Associativity.Right();
        case "non-assoc":
            return Associativity.NonAssoc();
        default:
            throw new AssertionError("Incorrect assoc string: " + assocOrig);
        }
    }

    public Set<org.kframework.definition.Sentence> apply(PriorityExtended pe) {
        Seq<scala.collection.Set<Tag>> seqOfSetOfTags = immutable(pe.getPriorityBlocks()
                .stream().map(block -> toTags(block.getProductions()))
                .collect(Collectors.toList()));

        return Sets.newHashSet(SyntaxPriority(seqOfSetOfTags));
    }

    public scala.collection.Set<Tag> toTags(List<KLabelConstant> labels) {
        return immutable(labels.stream().flatMap(l -> {
            Set<Production> productions = context.tags.get(l.getLabel());
            if(productions.isEmpty())
                throw KEMException.outerParserError("Could not find any productions for tag: "+l.getLabel(), l.getSource(), l.getLocation());
            return productions.stream().map(p -> Tag(p.getKLabel()));
        }).collect(Collectors.toSet()));
    }

    public Set<org.kframework.definition.Sentence> apply(Syntax s) {
        Set<org.kframework.definition.Sentence> res = new HashSet<>();

        org.kframework.frontend.Sort sort = apply(s.getDeclaredSort().getRealSort());

        // just a sort declaration
        if (s.getPriorityBlocks().size() == 0) {
            res.add(SyntaxSort(sort, inner.convertAttributes(s)));
            return res;
        }

        Function<PriorityBlock, scala.collection.Set<Tag>> applyToTags = (PriorityBlock b) -> immutable(b
                .getProductions().stream().filter(p -> p.getKLabel() != null).map(p -> Tag(p.getKLabel()))
                .collect(Collectors.toSet()));

        if (s.getPriorityBlocks().size() > 1) {
            res.add(SyntaxPriority(immutable(s.getPriorityBlocks().stream().map(applyToTags)
                    .collect(Collectors.toList()))));
        }

        // there are some productions
        for (PriorityBlock b : s.getPriorityBlocks()) {
            if (!b.getAssoc().equals("")) {
                Value assoc = applyAssoc(b.getAssoc());
                res.add(SyntaxAssociativity(assoc, applyToTags.apply(b)));
            }

            for (Production p : b.getProductions()) {
                if (p.containsAttribute("reject")) // skip productions of the old reject type
                    continue;
                // Handle a special case first: List productions have only
                // one item.
                if (p.getItems().size() == 1 && p.getItems().get(0) instanceof UserList) {
                    applyUserList(res, sort, p, (UserList) p.getItems().get(0));
                } else {
                    List<ProductionItem> items = new ArrayList<>();
                    for (org.kframework.frontend.kil.ProductionItem it : p.getItems()) {
                        if (it instanceof NonTerminal) {
                            items.add(Constructors.NonTerminal(apply(((NonTerminal) it).getRealSort())));
                        } else if (it instanceof UserList) {
                            throw new AssertionError("Lists should have applied before.");
                        } else if (it instanceof Lexical) {
                            String regex;
                            if (p.containsAttribute("regex"))
                                regex = p.getAttribute("regex");
                            else
                                regex = ((Lexical) it).getLexicalRule();
                            RegexTerminal regexTerminal = getRegexTerminal(regex);

                            items.add(regexTerminal);
                        } else if (it instanceof Terminal) {
                            items.add(Constructors.Terminal(((Terminal) it).getTerminal()));
                        } else {
                            throw new AssertionError("Unhandled case");
                        }
                    }

                    org.kframework.attributes.Att attrs = inner.convertAttributes(p);

                    org.kframework.definition.Production prod;
                    if (p.getKLabel() == null)
                        prod = Constructors.Production(
                                sort,
                                immutable(items),
                                attrs.add(KILtoInnerKORE.PRODUCTION_ID,
                                        "" + System.identityHashCode(p)));
                    else
                        prod = Constructors.Production(
                                p.getKLabel(),
                                sort,
                                immutable(items),
                                attrs.add(KILtoInnerKORE.PRODUCTION_ID,
                                        "" + System.identityHashCode(p)));

                    res.add(prod);
                    // handle associativity for the production
                    if (p.containsAttribute("left"))
                        res.add(SyntaxAssociativity(applyAssoc("left"), Set(Tag(p.getKLabel()))));
                    else if (p.containsAttribute("right"))
                        res.add(SyntaxAssociativity(applyAssoc("right"), Set(Tag(p.getKLabel()))));
                    else if (p.containsAttribute("non-assoc"))
                        res.add(SyntaxAssociativity(applyAssoc("non-assoc"), Set(Tag(p.getKLabel()))));
                }
            }
        }
        return res;
    }

    public static RegexTerminal getRegexTerminal(String regex) {
        String precede = "#";
        if (regex.startsWith("(?<!")) { // find the precede pattern in the beginning: (?<!X)
            int depth = 1;
            for (int i = 1; i < regex.length(); i++) {
                if (regex.charAt(i) == '\\') {
                    i++;
                    continue;
                }
                if (regex.charAt(i) == '(') depth++;
                if (regex.charAt(i) == ')') depth--;
                if (depth == 0) {
                    precede = regex.substring("(?<!".length(), i);
                    regex = regex.substring(i + 1);
                    break;
                }
            }
        }
        String follow = "#";
        int followIndex = regex.lastIndexOf("(?!");
        if (followIndex != -1 && regex.endsWith(")")) { // find the follow pattern at the end: (?!X)
            if (!(followIndex > 0 && regex.charAt(followIndex - 1) == '\\')) {
                follow = regex.substring(followIndex + "(?!".length(), regex.length() - 1);
                regex = regex.substring(0, followIndex);
            }
        }
        return RegexTerminal(precede, regex, follow);
    }

    public void applyUserList(Set<org.kframework.definition.Sentence> res,
                              org.kframework.frontend.Sort sort, Production p, UserList userList) {

        // Transform list declarations of the form Es ::= List{E, ","} into something representable in kore
        org.kframework.frontend.Sort elementSort = apply(userList.getSort());

        org.kframework.attributes.Att attrs = inner.convertAttributes(p).add(Att.userList(), userList.getListType());
        String kilProductionId = "" + System.identityHashCode(p);
        Att attrsWithKilProductionId = attrs.add(KILtoInnerKORE.PRODUCTION_ID, kilProductionId);
        org.kframework.definition.Production prod1, prod3;

        // Es ::= E "," Es
        prod1 = Constructors.Production(sort,
                Seq(Constructors.NonTerminal(elementSort), Constructors.Terminal(userList.getSeparator()), Constructors.NonTerminal(sort)),
                attrsWithKilProductionId.remove("klabel").add("klabel", p.getKLabel()).add("right"));


        // Es ::= ".Es"
        prod3 = Constructors.Production(sort, Seq(Constructors.Terminal("." + sort.toString())),
                attrsWithKilProductionId.remove("strict").remove("klabel").add("klabel", p.getTerminatorKLabel()));

        res.add(prod1);
        res.add(prod3);
    }

    public org.kframework.frontend.Sort apply(org.kframework.frontend.kil.Sort sort) {
        return ADT.SortLookup.apply(sort.getName());
    }
}
