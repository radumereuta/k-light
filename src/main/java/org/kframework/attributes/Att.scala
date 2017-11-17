package org.kframework.attributes

import scala.collection._

case class Att(att: Map[String, Option[String]]) extends AttributesToString {

  def get(key: String): Option[Option[String]] = att.get(key)

  def contains(key: String): Boolean = att.contains(key)

  def add(key: String):Att = Att(att + (key -> None))

  def add(key: String, value: String):Att = Att(att + (key -> Some(value)))

  def remove(key: String):Att = Att(att - key)

  def ++(that: Att) = Att(att ++ that.att)

  override lazy val hashCode: Int = scala.runtime.ScalaRunTime._hashCode(Att.this)
}

object Att {
  @annotation.varargs def apply(atts: (String, Option[String])*): Att = Att(atts.toMap)
  @annotation.varargs def applyVararg(atts: (String, Option[String])*): Att = Att(atts.toMap)
  val userList = "userList"
  val generatedByListSubsorting = "generatedByListSubsorting"
  val generatedByAutomaticSubsorting = "generatedByAutomaticSubsorting"
  val allowChainSubsort = "allowChainSubsort"
  val generatedBy = "generatedBy"
  val kLabelAttribute:String = "klabel"
}

trait AttributesToString {
  self: Att =>

  override def toString:String =
    "[" +
      (this.filteredAtt map {
        case (key, Some(value)) => key.toString + "(" + value + ")"
        case (key, None) => key.toString
      }).toList.sorted.mkString(" ") +
      "]"

  def postfixString:String = {
    if (filteredAtt.isEmpty) "" else " " + toString()
  }

  lazy val filteredAtt: Map[String, Option[String]] =
    att filter { case ("productionID", _) => false; case _ => true }
}
