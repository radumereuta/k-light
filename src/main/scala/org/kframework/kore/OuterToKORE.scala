package org.kframework.kore

import org.kframework.definition._
import org.kframework.frontend.ADT
import org.kframework.parser.concrete2kore.generator.RuleGrammarGenerator

object OuterToKORE {

  def apply(d: Definition): String = {
    "[]\n" +
      "module INJ\n" +
      "  sort String{} []\n" +
      "  sort KInt{} []\n" +
      "  symbol inj{Sin,Sout}(Sin):Sout []\n" +
      "  symbol cast{C}(C):C []\n" +
      "  symbol rew{C}(C,C):C []\n" +
      "  symbol info{S}(String{}, S) : S []\n" +
      "  symbol input{}(KInt{}, KInt{}, KInt{}, KInt{}) : String{} []\n" +
      "endmodule []\n\n" +
      (d.modules map (m => apply(m, d))) .mkString("\n")
  }

  def apply(m: Module, d:Definition): String = {
    "module " + m.name + "\n" +
      "  import INJ []\n" +
      (m.imports map (i => "  import " + i.name + " []\n")).mkString("") +
      (m.localSorts map (s => "  sort " + s.localName + "{} []\n")).mkString("") + // make sure all sorts are declared
      (m.localSentences map (s => apply(s, m, d))).mkString("\n") +
      "\nendmodule []\n"
  }

  def apply(i:ProductionItem):String = i match {
    case NonTerminal(sort, _, _) => sort.localName + "{}"
    case _ => ""
  }

  def apply(s: Sentence, m:Module, d:Definition): String = s match {
    case SyntaxSort(_, _, _, _) => ""
    case p@Production(sort, items, att, _, _) =>
      if (p.att.contains("token") || p.symbol.isEmpty || p.symbol.get.equals("inj") || p.symbol.get.equals("cast") || p.symbol.get.equals("rew")) return ""
      val sin = (items.filter((i) => i.isInstanceOf[NonTerminal]) map apply).mkString(", ")
      val inType = if (p.symbol.get == "inj" || p.symbol.get == "cast") sin + "," + sort.localName + "{}" else ""
      "  symbol " + p.symbol.get + "{" + inType + "}(" + sin + "):" + sort.localName + "{} []"
    case b@Bubble(_, _, _, _, _) => "  /* input(" + b.att.get("start").orElse(Some(Some("K"))).get.get + "): " + b.contents + "*/\n" +
      "  axiom{} " + parseToKORE(b, m, d) + " []"
    case ModuleComment(_, _, _, _) => ""
    case SyntaxAssociativity(_, _, _, _, _) => ""
    case SyntaxPriority(_, _, _, _) => ""
  }

  def parseToKORE(b:Bubble, m:Module, d:Definition): String = {
    val parser = RuleGrammarGenerator.getCombinedGrammar(RuleGrammarGenerator.getProgramsGrammar(m, d))
    val rez = parser.parseStringTerm(
      b.contents.trim,
      ADT.SortLookup(b.att.get("start").flatten.orElse(Some("K")).get),
      b.source,
      Integer.parseInt(b.att.get("contentStartLine").get.get),
      Integer.parseInt(b.att.get("contentStartColumn").get.get),
      true)
    if (rez._1.isLeft)
      rez._1.left.get.toString
    else
      TreeNodesToKORE.print(rez._1.right.get)
  }
}
