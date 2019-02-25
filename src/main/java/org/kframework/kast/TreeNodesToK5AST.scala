package org.kframework.kast

import java.util

import org.kframework.treeNodes.{Term, _}
import org.kframework.utils.StringUtil

import scala.collection.JavaConverters._

object TreeNodesToK5AST {

  def apply(t: Term): String = t match {
    case c@Constant(s, p) => "#token(" + StringUtil.enquoteCString(s) + "," + StringUtil.enquoteCString(p.sort.localName) + ")"
    case tc@TermCons(items, p) => p.symbol.get + "(" +
      (if (items.isEmpty)
        ".KList"
      else
        (new util.ArrayList(items).asScala.reverse map apply).mkString(",")) +
      ")"
    case Ambiguity(items) => //"amb(" + (items.asScala map apply).mkString(",") + ")"
      items.asScala.foldRight("bottom(.KList)") { (i, acc) => "amb(" + apply(i) + "," + acc + ")" }
  }
}

object TreeNodesToK5MetaAST {

  def apply(t: Term): String = t match {
    case c@Constant(s, p) => "#KToken(" +
      "#token(" + StringUtil.enquoteCString(s) + ", \"MetaValue\"), " +
      "#token(" + StringUtil.enquoteCString(p.sort.localName) + ", \"MetaKSort\"))"
    case tc@TermCons(items, p) => "#KApply(" +
      "#token(" + StringUtil.enquoteCString(p.symbol.get) + ", \"MetaKLabel\"), " +
      (if (items.isEmpty)
        "#EmptyKList(.KList)"
      else
        new util.ArrayList(items).asScala.reverse.foldRight("#EmptyKList(.KList)"){ (i, acc) => "#KList(" + apply(i) + "," + acc + ")"}) +
      ")"
    case Ambiguity(items) => //"amb(" + (items.asScala map apply).mkString(",") + ")"
      items.asScala.foldRight("bottom(.KList)") { (i, acc) => "amb(" + apply(i) + "," + acc + ")" }
  }
}
