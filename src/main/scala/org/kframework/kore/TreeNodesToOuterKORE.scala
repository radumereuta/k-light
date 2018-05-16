package org.kframework.kore

import java.util

import org.kframework.treeNodes.{Term, _}

import scala.collection.JavaConverters._
import scala.collection.mutable

/**
  * Used to transform entire .k file into .kore.
  * Designed to be a pretty printer for the output of texts parsed with outer.k.
  */
object TreeNodesToOuterKORE {

  // cases for the types of nodes - actual printing of the node
  def apply(t:Term): String = t match {
    case Constant(s, p) => s
    case tc@TermCons(items, p) =>
      val itms = new util.ArrayList(items).asScala.reverse
      p.klabel.get match {
      case "#KDefinition" => "[]\n" + apply(itms)
      case "#KModule" =>
        "module " + apply(items.get(2)) + "\n" +
        apply(items.get(1)) +
        apply(items.get(0)) +
        "endmodule []\n"
      case "#KImport" => "  import " + apply(itms) + " []\n"
      case "#KSyntaxSort" => "  sort " + apply(itms) + " []\n"
      case "#KSyntaxProduction" => applySyntax("", apply(tc.items.get(1)), tc.items.get(0))
      case "#KSyntaxProductionWParam" => applySyntax("{" + apply(tc.items.get(2)) + "}", apply(tc.items.get(1)), tc.items.get(0))

      // print sorts
      case "#emptyKSortList" => ""
      case "#paramSort" => apply(items.get(1)) + "{" + apply(items.get(0)) + "}"
      case "#KSortList" => apply(items.get(1)) + "," + apply(items.get(0))

      case _ => apply(itms)
    }
    case Ambiguity(items) =>
      throw new UnsupportedOperationException("Ambiguities not expected from this grammar.")
  }
  def apply(itms: mutable.Buffer[Term]): String = {
    (itms map apply).mkString("")
  }

  // collect production items
  def collectPItems(t:Term): List[String] = t match {
    case TermCons(items, p) => p.klabel.get match {
      case "#KProduction" => collectPItems(items.get(1)) ++ collectPItems(items.get(0))
      case "#nonTerminal" => List(apply(items.get(0)))
      case "#regularTermina" => List.empty
      case "#regexTerminal" => List.empty
    }
  }

  def applySyntax(paramList:String, prodSort:String, t:Term): String = t match {
    case tc@TermCons(items, p) => p.klabel.get match {
      case "#KProductionWAttr" => "  symbol " + getKLabel(tc).get + paramList + "(" + collectPItems(items.get(1)).mkString(",") + "): " + prodSort + " []\n"
      case _ => (items.asScala map { (i) => applySyntax(paramList, prodSort, i)}).mkString("")
    }
    case Constant(value, _) =>
      value
  }

  def getKLabel(t:Term): Option[String] = getTagValue(t, "klabel")
  def getTagValue(t:Term, tag:String): Option[String] = t match {
    case Constant(_, _) => Option.empty
    case TermCons(items, p) =>
      if (p.klabel.get.equals("#TagContent")) {
        val value:Constant = items.get(0).asInstanceOf[Constant]
        val key:Constant = items.get(1).asInstanceOf[Constant]
        if (key.value.equals(tag))
          return Option.apply(value.value)
        else
          return Option.empty
      }
      // find first node that defines a klabel
      (items.asScala map getKLabel).foldRight(Option.empty[String]){(i, acc) => { if (acc.isDefined) acc else if (i.isDefined) i else Option.empty}}
  }
}
