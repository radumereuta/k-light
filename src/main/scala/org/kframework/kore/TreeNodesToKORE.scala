package org.kframework.kore

import java.util

import org.kframework.definition.NonTerminal
import org.kframework.treeNodes._
import org.kframework.utils.StringUtil

import scala.collection.JavaConverters._

object TreeNodesToKORE {

  def apply(t: Term): String = t match {
    case Constant(s, p) => "\\dv{" + p.sort.localName + "{}}(" + StringUtil.enquoteCString(s) + ")"
    case TermCons(items, p) => p.klabel.get match {
      case "inj" => "inj{" + p.items.iterator.next().asInstanceOf[NonTerminal].sort.localName + "{}," + p.sort.localName + "{}}(" + (new util.ArrayList(items).asScala.reverse map apply).mkString(",") + ")"
      case _ => p.klabel.get + "{}(" + (new util.ArrayList(items).asScala.reverse map apply).mkString(",") + ")"
    }
    case Ambiguity(items) =>
      makeCons(items.asScala.toList, items.iterator.next().asInstanceOf[ProductionReference].production.sort.localName)
  }
  def makeCons(c:List[Term], sort:String):String = c match {
    case h :: tail => "\\or{" + sort + "{}}(" + apply(h) + "," + makeCons(tail, sort) + ")"
    case Nil => "\\bottom{" + sort + "{}}()"
  }
}
