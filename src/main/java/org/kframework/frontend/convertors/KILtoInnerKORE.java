// Copyright (c) 2014-2016 K Team. All Rights Reserved.

package org.kframework.frontend.convertors;

import org.kframework.attributes.Att;
import org.kframework.attributes.Location;
import org.kframework.attributes.Source;
import org.kframework.builtin.Labels;
import org.kframework.builtin.Sorts;
import org.kframework.frontend.KApply;
import org.kframework.frontend.KLabel;
import org.kframework.frontend.KList;
import org.kframework.frontend.KRewrite;
import org.kframework.frontend.KVariable;
import org.kframework.frontend.kil.*;
import org.kframework.frontend.kil.Attributes;
import org.kframework.frontend.kil.loader.Context;
import org.kframework.meta.Up;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import static org.kframework.utils.Collections.*;
import static org.kframework.utils.Collections.immutable;
import static org.kframework.frontend.KORE.*;

@SuppressWarnings("unused")
public class KILtoInnerKORE extends KILTransformation<K> {

    private Context context;

    private KLabel KLabel(String name) {
        return KORE.KLabel(dropQuote(name));
    }

    public KILtoInnerKORE(org.kframework.frontend.kil.loader.Context context) {
        this.context = context;
    }

    public static final String PRODUCTION_ID = "productionID";
    public static final String LIST_TERMINATOR = "listTerminator";

    public static final Labels labels = new Labels(KORE.constructor());

    public K apply(Bag body) {
        List<K> contents = body.getContents().stream().map(this).collect(Collectors.toList());
        return KApply(labels.KBag(), (KORE.KList(contents)));
    }

    // public K apply(TermComment c) {
    // return KList();
    // }

    private K cellMarker = org.kframework.definition.Configuration.cellMarker();

    @SuppressWarnings("unchecked")
    public KApply apply(Cell body) {
        // K x = ;
        // if (x instanceof KApply && ((KApply) x).klabel() == Labels.KBag()
        // && ((KApply) x).size() == 0) {

        return KApply(KLabel(body.getLabel()), KList(apply(body.getContents())),
                Attributes(cellMarker).addAll(convertCellAttributes(body)));
        // } else {
        // return KApply(KLabel(body.getLabel()), KList(x),
        // Att(cellMarker));
        // }
    }

    public K apply(org.kframework.frontend.kil.KLabelConstant c) {
        return InjectedKLabel(KLabel(c.getLabel()), Attributes());
    }

    public org.kframework.frontend.KSequence apply(KSequence seq) {
        return KORE.KSequence(apply(seq.getContents()));
    }

    private List<K> apply(List<Term> contents) {
        return contents.stream().map(this).collect(Collectors.toList());
    }

    public org.kframework.frontend.KApply apply(Bracket b) {
        Object content = apply(b.getContent());
        if (content instanceof KList) {
            content = KApply(KLabel(KORE.injectedKListLabel()), (KList) content);
        }
        return KApply(KLabel("bracket"), KList((K) content));
    }

    public KApply apply(TermCons cons) {
        org.kframework.attributes.Att att = attributesFor(cons);
        return KApply(KLabel(cons.getProduction().getKLabel()), KORE.KList(apply(cons.getContents())),
                att);
    }

    public KApply apply(ListTerminator t) {
        Production production = context.listProductions.get(t.getSort());
        String terminatorKLabel = production.getTerminatorKLabel();

        // NOTE: we don't covert it back to ListTerminator because Radu thinks
        // it is not necessary

        return KApply(KLabel(terminatorKLabel), KORE.KList(), Attributes().add(LIST_TERMINATOR));
    }

    public String dropQuote(String s) {
        return s;
    }

    public K apply(KApp kApp) {
        Term label = kApp.getLabel();

        if (label instanceof Token) {
            return KToken(((Token) label).value(), Sort(((Token) label).tokenSort().getName()));
        } else {
            Term child = kApp.getChild();

            if (child instanceof org.kframework.frontend.kil.KList) {
                return KApply(applyToLabel(label), (KList) apply(child),
                        convertAttributes(kApp));
            } else if (child instanceof org.kframework.frontend.kil.Variable) {
                return KApply(applyToLabel(label), KList(apply(child)), convertAttributes(kApp));
            } else {
                throw new AssertionError("encountered " + child.getClass() + " in a KApp");
            }
        }
    }

    public KLabel applyToLabel(Term label) {
        if (label instanceof KLabelConstant) {
            return KLabel(dropQuote(((KLabelConstant) label).getLabel()));
        } else if (label instanceof KApp) {
            throw new RuntimeException(label.toString());
        } else if (label instanceof Variable) {
            return (KLabel) apply(label);
        }
        throw new RuntimeException(label.getClass().toString());
    }

    public KList apply(org.kframework.frontend.kil.KList kList) {
        return (KList) kList.getContents().stream().map(this).collect(toKList());
    }

    private org.kframework.attributes.Att attributesFor(TermCons cons) {
        String uniqueishID = "" + System.identityHashCode(cons.getProduction());
        org.kframework.attributes.Att att = sortAttributes(cons).add(PRODUCTION_ID, uniqueishID);
        return att;
    }

    private org.kframework.attributes.Att sortAttributes(Term cons) {

        return convertAttributes(cons).addAll(
                Attributes(KApply(KLabel("sort"),
                        KList(KToken(cons.getSort().toString(), Sorts.KString())))));
    }

    public KApply apply(Hole hole) {
        return KApply(labels.Hole(), KList(KToken("", Sort(hole.getSort().getName()))),
                sortAttributes(hole));
    }

    public KVariable apply(Variable v) {
        return KVariable(v.getName(), sortAttributes(v));
    }

    public KRewrite apply(Rewrite r) {
        Object right = apply(r.getRight());
        if (right instanceof KList)
            right = KApply(KLabel(KORE.injectedKListLabel()), (KList) right);

        Object left = apply(r.getLeft());
        if (left instanceof KList)
            left = KApply(KLabel(KORE.injectedKListLabel()), (KList) left);

        return KRewrite((K) left, (K) right, sortAttributes(r));
    }

    public K applyOrTrue(Term t) {
        if (t != null)
            return apply(t);
        else
            return KToken("true", Sorts.Bool());
    }

    public K apply(TermComment t) {
        return KORE.KSequence();
    }

    public org.kframework.attributes.Att convertAttributes(ASTNode t) {
        Attributes attributes = t.getAttributes();

        Set<K> attributesSet = attributes
                .keySet()
                .stream()
                .map(key -> {
                    String keyString = key.toString();
                    String valueString = attributes.get(key).getValue().toString();
                    if (keyString.equals("klabel")) {
                        return (K) KApply(KLabel("klabel"),
                                KList(KToken(dropQuote(valueString), Sort("AttributeValue"))));
                    } else {
                        return (K) KApply(KLabel(keyString),
                                KList(KToken(valueString, Sort("AttributeValue"))));
                    }

                }).collect(Collectors.toSet());

        return Attributes(immutable(attributesSet))
                .addAll(attributesFromLocation(t.getLocation()))
                .addAll(attributesFromSource(t.getSource()));
    }

    private Att attributesFromSource(Source source) {
        Up up = new Up(KORE.self(), Set("org.kframework.attributes"));
        if (source != null) {
            return Att.apply(Set(up.apply(source)));
        }
        return Attributes();
    }

    public org.kframework.attributes.Att convertCellAttributes(Cell c) {
        Map<String, String> attributes = c.getCellAttributes();

        Set<K> attributesSet = attributes
                .keySet()
                .stream()
                .map(key -> {
                    String value = attributes.get(key);
                    return (K)KApply(KLabel(key), KList(KToken(value, Sort("AttributeValue"))));
                }).collect(Collectors.toSet());

        return Attributes(immutable(attributesSet));
    }

    private org.kframework.attributes.Att attributesFromLocation(Location location) {
        Up up = new Up(KORE.self(), Set("org.kframework.attributes"));

        if (location != null) {
            return org.kframework.attributes.Att.apply(Set(up.apply(location)));
        } else
            return Attributes();
    }
}
