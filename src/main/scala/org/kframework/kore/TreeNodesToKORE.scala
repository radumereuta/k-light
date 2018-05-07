package org.kframework.kore

import java.util

import org.kframework.attributes.Location
import org.kframework.definition.NonTerminal
import org.kframework.treeNodes.{Term, _}
import org.kframework.utils.StringUtil

import scala.collection.JavaConverters._

object TreeNodesToKORE {

  def print(t: Term): String = {
    val vis: TreeNodesToKOREVisitor = new TreeNodesToKOREVisitor()
    vis.visit(t)
    val root: String = vis.apply(t)
    val sort: String = t match {
      case Ambiguity(items) => items.iterator().next().asInstanceOf[ProductionReference].production.sort.localName + "{}"
      case p: ProductionReference => p.production.sort.localName + "{}"
    }
    val rez = vis.shared.foldLeft(
      vis.shared.foldLeft(root) { (acc, i) =>
        "    \\and{" + sort + "}(\n" +
          "        \\equals{" + i._2.get._3 + "," + sort + "}(" + i._2.get._1 + "," + i._2.get._2 + "),\n" + acc + ")"
      }
    ) { (acc, i) => "\\exists{" + sort + "}(" + i._2.get._1 + ",\n" + acc + ")" }
    "\n" + rez
  }
}

private class TreeNodesToKOREVisitor {
  var shared: Map[Term, Option[(String, String, String)]] = Map.empty // mark all the nodes which appear multiple times in the AST
  private var visited: Set[Term] = Set.empty
  private var seed: Int = 0

  // find and mark all the nodes which appear multiple times in the AST
  def visit(t: Term): Unit = {
    if (t.isInstanceOf[TermCons] && visited.contains(t))
      shared = shared + (t -> Option.empty)
    else {
      visited = visited + t
      t match {
        case h: HasChildren => h.items.asScala foreach visit
        case _ =>
      }
    }
  }

  // traverse the DAG, if a node is shared, mark it with a variable and store it
  def apply(t: Term): String = {
    if (shared.contains(t)) {
      val pair: Option[(String, String, String)] = shared(t)
      if (pair.isDefined) {
        pair.get._1
      } else {
        val printed: String = doMatch(t)
        val sort: String = t match {
          case a: Ambiguity => a.items.iterator().next().asInstanceOf[ProductionReference].production.sort.localName + "{}"
          case p: ProductionReference => p.production.sort.localName + "{}"
        }
        val variable: String = "V" + seed + ":" + sort
        seed = seed + 1
        shared = shared.updated(t, Some(variable, printed, sort))
        variable
      }
    } else
      doMatch(t)
  }

  // cases for the types of nodes - actual printing of the node
  private def doMatch(t: Term): String = t match {
    //case c@Constant(s, p) => printInfo(c, "\\dv{" + p.sort.localName + "{}}(" + StringUtil.enquoteCString(s) + ")")
    case tc@TermCons(items, p) => printInfo(tc, p.klabel.get match {
      case "inj" => "inj{" + p.items.iterator.next().asInstanceOf[NonTerminal].sort.localName + "{}," + p.sort.localName + "{}}(" + (new util.ArrayList(items).asScala.reverse map apply).mkString(",") + ")"
      case _ => p.klabel.get + "{}(" + (new util.ArrayList(items).asScala.reverse.filter(p1 => !p1.isInstanceOf[Constant]) map apply).mkString(",") + ")"
    })
    case Ambiguity(items) =>
      val sort: String = items.iterator.next().asInstanceOf[ProductionReference].production.sort.localName
      items.asScala.foldRight("\\bottom{" + sort + "{}}()") { (i, acc) => "\\or{" + sort + "{}}(" + apply(i) + "," + acc + ")" }
  }

  // meta information wrap
  private def printInfo(tc: TermCons, printedTerm: String): String = {
    // return printedTerm // uncomment to not print info - makes it easier to read terms
    "info{" + tc.production.sort.localName + "{}}(" +
      tc.items.asScala.filter(t => t.isInstanceOf[Constant]).foldRight(
        "\\and{String{}}(" +
          printInput(tc) + "," +
          "\\equals{String{},String{}}(" + printInput(tc) + "," + tc.items.asScala.foldLeft("emptyString{}()") { (acc, i) => "stringAdd{}(" + printInput(i) + "," + acc + ")" }
          + "))"
      ) { (i, acc) =>
        "\\and{String{}}(" +
          "\\equals{String{},String{}}(" + printInput(i) + ",\\dv{String{}}(" + StringUtil.enquoteCString(i.asInstanceOf[Constant].value) + "))," +
          acc + ")"
      } + "," +
      printedTerm +
      ")"
  }

  private def printInput(t: Term): String = {
    "input{}(\\dv{KInt{}}(\"" + printLoc(t) + "\"))"
  }

  private def printLoc(t: Term): String = {
    val loc = t match {
      case ambiguity: Ambiguity => ambiguity.items.iterator().next().location.get()
      case _ => t.location.get()
    }
    loc.startLine + "," + loc.startColumn + "," + loc.endLine + "," + loc.endColumn
  }
}
