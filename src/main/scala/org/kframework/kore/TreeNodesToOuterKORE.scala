package org.kframework.kore

import java.util

import org.kframework.treeNodes.{Term, _}

import scala.collection.JavaConverters._
import scala.collection.mutable

/**
  * Used to transform entire .k file into .kore.
  * Designed to be a pretty printer of the output of parsing with outer.k.
  */
object TreeNodesToOuterKORE {

  // cases for the types of nodes - actual printing of the node
  def apply(t:Term): String = t match {
    case c@Constant(s, p) => s
    case tc@TermCons(items, p) =>
      val itms = new util.ArrayList(items).asScala.reverse
      p.klabel.get match {
      case "#KDefinition" => "[]\n" + apply(itms)
      case "#KModule" =>
        val iter = itms.iterator
        "module " + apply(iter.next()) + "\n" +
        apply(iter.next()) +
        apply(iter.next()) +
        "endmodule []\n"
      case "#KImport" => "  import " + apply(itms) + " []\n"
      case "#KSyntaxSort" => "  sort " + apply(itms) + " []\n"
      case "#KSyntaxProduction" => applySyntax(tc, tc)

      case _ => apply(itms)
    }
    case Ambiguity(items) =>
      throw new UnsupportedOperationException("Shouldn't get any ambiguities from this grammar.")
  }
  def apply(itms: mutable.Buffer[Term]): String = {
    (itms map apply).mkString("")
  }

  def applySyntax(head:TermCons, t:Term): String = t match {
    case tc@TermCons(items, p) => p.klabel.get match {
      case "#KProductionWAttr" => "  symbol " + head.items.get(1) + " []\n"
      case _ => (items.asScala map { (i) => applySyntax(head, i)}).mkString("")
    }
    case Constant(value, _) => value
  }

  def getKLabel(t:Term): Option[String] = t match {
    case Constant(_, _) => Option.empty
    case TermCons(items, p) =>
      if (p.klabel.get.equals("#TagContent")) {
        val value:Constant = items.get(0).asInstanceOf[Constant]
        val key:Constant = items.get(1).asInstanceOf[Constant]
        if (key.value.equals("klabel"))
          return Option.apply(value.value)
        else
          return Option.empty
      }
      // find first node that defines a klabel
      (items.asScala map getKLabel).foldRight(Option.empty[String]){(i, acc) => { if (acc.isDefined) acc else if (i.isDefined) i else Option.empty}}
  }
}
