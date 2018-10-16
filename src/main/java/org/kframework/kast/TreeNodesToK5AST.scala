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
    case Ambiguity(items) => "amb(" + (items.asScala map apply).mkString(",") + ")"
  }
}
