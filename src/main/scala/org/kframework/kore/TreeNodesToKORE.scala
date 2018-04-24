package org.kframework.kore

import java.util

import org.kframework.definition.NonTerminal
import org.kframework.treeNodes._
import org.kframework.utils.StringUtil
import org.pcollections.ConsPStack

import scala.collection.JavaConverters._

object TreeNodesToKORE {

  def apply(t: Term): String = t match {
    case Constant(s, p) => "\\dv{" + p.sort.localName + "{}}(" + StringUtil.enquoteCString(s) + ")"
    case TermCons(items, p) => p.klabel.get match {
      case "inj" => "inj{" + p.items.iterator.next().asInstanceOf[NonTerminal].sort.localName + "{}," + p.sort.localName + "{}}(" + (new util.ArrayList(items).asScala.reverse map apply).mkString(",") + ")"
      case _ => p.klabel.get + "{}(" + (new util.ArrayList(items).asScala.reverse map apply).mkString(",") + ")"
    }
    case Ambiguity(items) => "\\or{" + items.iterator.next().asInstanceOf[ProductionReference].production.sort.localName + "{}}(" + (items.asScala.toList map apply).mkString(",") + ")"
  }
}


object TreeNodesToKORE2 {

  def apply(t: Term): String = t match {
    case c@Constant(v, p) => v
    case t@TermCons(items, p) => p.klabel.get match {
      case "sort" => items.get(1) match {
                        case Constant(v1, p1) => v1 + "{" + apply(items.get(0)) + "}" }
      case "empty" => ""
      case "_,_" => apply(items.get(1)) + "," + apply(items.get(0))
      case "input" => "input(" + apply(items.get(1)) + "," + apply(items.get(0)) + ")"
      case "symbol" => apply(items.get(2)) + "{" + apply(items.get(1)) + "}(" + apply(items.get(0)) + ")"
      case "\\and"    => "\\and{"    + items.iterator.next().asInstanceOf[ProductionReference].production.sort.localName + "{}}(" + (items.asScala.reverse.toList map apply).mkString(",") + ")"
      case "\\or"     => "\\or{"     + items.iterator.next().asInstanceOf[ProductionReference].production.sort.localName + "{}}(" + (items.asScala.reverse.toList map apply).mkString(",") + ")"
      case "\\equals" => "\\equals{" + items.iterator.next().asInstanceOf[ProductionReference].production.sort.localName + "{}}(" + (items.asScala.reverse.toList map apply).mkString(",") + ")"
      case _ => p.klabel.get + "{}(" + (items.asScala.reverse map apply).mkString(",") + ")"
    }
    case Ambiguity(items) => "\\or{" + items.iterator.next().asInstanceOf[ProductionReference].production.sort.localName + "{}}(" + (items.asScala.toList map apply).mkString(",") + ")"
  }
}

object ReverseChildren extends SafeTransformer {
  override def apply(tc:TermCons):Term = super.apply(TermCons.apply(ConsPStack.from(tc.items.asScala.reverse.asJava), tc.production, tc.location, tc.source))
}
