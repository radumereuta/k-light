package org.kframework.kore

import java.util

import org.kframework.definition.NonTerminal
import org.kframework.treeNodes.{Term, _}
import org.kframework.utils.StringUtil

import scala.collection.JavaConverters._

object TreeNodesToKORE {

  /**
    * Print the resulting AST with info nodes that contain location information
    * @param t input treeNode
    * @return String representation in the KORE format
    */
  def printWithInfo(t: Term): String = {
    val vis: TreeNodesToKOREVisitor = new TreeNodesToKOREVisitor(true)
    vis.printWithInfo(t)
  }

  /**
    * Print the resulting AST
    * @param t input treeNode
    * @return String representation in the KORE format
    */
  def print(t: Term): String = {
    val vis: TreeNodesToKOREVisitor = new TreeNodesToKOREVisitor(false)
    vis.printWithInfo(t)
  }
}

private class TreeNodesToKOREVisitor(info:Boolean) {
  var shared: Map[Term, Option[(String, String, String)]] = Map.empty // mark all the nodes which appear multiple times in the AST
  private var visited: Set[Term] = Set.empty
  private var seed: Int = 0
  private var doShare = false


  def printWithInfo(t:Term): String = {
    visit(t)
    val root:String = apply(t)
    val sort:String = t match {
      case Ambiguity(items) => items.iterator().next().asInstanceOf[ProductionReference].production.sort.localName + "{}"
      case p:ProductionReference => p.production.sort.localName + "{}"
    }
    val rez = shared.foldRight(
      shared.foldRight(root) { (i, acc) =>
        "    \\and{" + sort + "}(\n" +
          "        \\equals{" + i._2.get._3 + "," + sort + "}(" + i._2.get._1 + "," + i._2.get._2 + "),\n" + acc + ")"}
    ) { (i, acc) => "\\exists{" + sort + "}(" + i._2.get._1 + ",\n" + acc + ")" }
    "\n" + rez
  }

  // find and mark all the nodes which appear multiple times in the AST
  def visit(t:Term):Unit = {
    if (doShare && visited.contains(t))
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
    if (doShare && shared.contains(t)) {
      val pair: Option[(String, String, String)] = shared(t)
      if (pair.isDefined) {
        pair.get._1
      } else {
        val printed: String = doMatch(t)
        val sort: String = t match {
          case a:Ambiguity => a.items.iterator().next().asInstanceOf[ProductionReference].production.sort.localName + "{}"
          case p:ProductionReference => p.production.sort.localName + "{}" }
        val variable: String = "V" + seed + ":" + sort
            seed = seed + 1
            shared = shared.updated(t, Some(variable, printed, sort))
            variable
      }
    } else
      doMatch(t)
  }
  // cases for the types of nodes - actual printing of the node
  private def doMatch(t:Term): String = t match {
    case c@Constant(s, p) => printInfo(c, "\\dv{Sort" + p.sort.localName + "{}}(" + StringUtil.enquoteCString(s) + ")")
    case tc@TermCons(items, p) => printInfo(tc, p.klabel.get match {
      case "inj" => "inj{" + p.items.iterator.next().asInstanceOf[NonTerminal].sort.localName + "{}," + p.sort.localName + "{}}(" + (new util.ArrayList(items).asScala.reverse map apply).mkString(",") + ")"
      case "cast" => "cast{" + p.sort.localName + "{}}(" + (new util.ArrayList(items).asScala.reverse map apply).mkString(",") + ")"
      case "bracket" => "bracket{" + p.sort.localName + "{}}(" + (new util.ArrayList(items).asScala.reverse map apply).mkString(",") + ")"
      case "\\rewrites" => "\\rewrites{" + p.sort.localName + "{}}(" + (new util.ArrayList(items).asScala.reverse map apply).mkString(",") + ")"
      case _ => "Lbl" + p.klabel.get + "{}(" + (new util.ArrayList(items).asScala.reverse map apply).mkString(",") + ")"
    })
    case Ambiguity(items) =>
      val sort: String = items.iterator.next().asInstanceOf[ProductionReference].production.sort.localName
      items.asScala.foldRight("\\bottom{" + sort + "{}}()") { (i, acc) => "\\or{" + sort + "{}}(" + apply(i) + "," + acc + ")" }
  }
  // meta information wrap
  private def printInfo(t: ProductionReference, printedTerm:String): String = {
    if (info)
    "info{" + t.production.sort.localName + "{}}(" +
      "input{}(\\dv{KInt{}}(\"" + t.location.get().startLine +
      "\"),\\dv{KInt{}}(\"" + t.location.get().startColumn +
      "\"),\\dv{KInt{}}(\"" + t.location.get().endLine +
      "\"),\\dv{KInt{}}(\"" + t.location.get().endColumn + "\"))," +
      printedTerm +
      ")"
    else
      printedTerm // do not print the large info nodes to make the AST more readable
  }
}
