// Copyright (c) 2014 K Team. All Rights Reserved.

package org.kframework.definition

import org.kframework.attributes.{Att, Location, Source}
import org.kframework.frontend._
import org.kframework.{attributes, definition}

import scala.collection._

/**
 *
 * Helper constructors for KORE definition.classes. The class is meant to be imported
 * statically.
 *
 */

object Constructors {

  def Definition(mainModule: Module, modules: Set[Module], att: Att) =
    definition.Definition(mainModule, modules, att)

  def Module(name: String, sentences: Set[Sentence]) = definition.Module(name, Set(), sentences, Att(), Option.empty[Location], Source("generated"))
  def Module(name: String, sentences: Set[Sentence], att: attributes.Att) = definition.Module(name, Set(), sentences, att, Option.empty[Location], Source("generated"))
  def Module(name: String, imports: Set[Module], sentences: Set[Sentence], att: attributes.Att) = definition.Module(name, imports, sentences, att, Option.empty[Location], Source("generated"))

  def SyntaxSort(sort: Sort) = definition.SyntaxSort(sort, Att(), Option.empty, Source("generated"))
  def SyntaxSort(sort: Sort, att: attributes.Att) = definition.SyntaxSort(sort, att, Option.empty, Source("generated"))

  def Production(sort: Sort, items: Seq[ProductionItem]) = definition.Production(sort, items, Att(), Option.empty, Source("generated"))
  def Production(sort: Sort, items: Seq[ProductionItem], att: attributes.Att) = definition.Production(sort, items, att, Option.empty, Source("generated"))
  def Production(klabel: String, sort: Sort, items: Seq[ProductionItem]) = definition.Production(sort, items, Att().add(klabel), Option.empty, Source("generated"))
  def Production(klabel: String, sort: Sort, items: Seq[ProductionItem], att: attributes.Att) = definition.Production(sort, items, att.add("symbol", klabel), Option.empty, Source("generated"))

  def Terminal(s: String) = definition.Terminal(s, Seq(), Option.empty, Source("generated"))
  def NonTerminal(sort: Sort) = definition.NonTerminal(sort, Option.empty, Source("generated"))
  def RegexTerminal(regexString: String) = definition.RegexTerminal("#", regexString, "#", Option.empty, Source("generated"))
  def RegexTerminal(precedeRegexString: String, regexString: String, followRegexString: String) = definition.RegexTerminal(precedeRegexString, regexString, followRegexString, Option.empty, Source("generated"))

  def Tag(s: String) = definition.Tag(s)

  def SyntaxPriority(priorities: Seq[Set[Tag]]) = definition.SyntaxPriority(priorities, Att(), Option.empty, Source("generated"))
  def SyntaxPriority(priorities: Seq[Set[Tag]], att: attributes.Att) = definition.SyntaxPriority(priorities, att, Option.empty, Source("generated"))

  def SyntaxAssociativity(assoc: definition.Associativity.Value, tags: Set[Tag]) = definition.SyntaxAssociativity(assoc, tags, Att(), Option.empty, Source("generated"))
  def SyntaxAssociativity(assoc: definition.Associativity.Value, tags: Set[Tag], att: attributes.Att) = definition.SyntaxAssociativity(assoc, tags, att, Option.empty, Source("generated"))

  def Bubble(sentenceType: String, content: String, att: attributes.Att) =
    definition.Bubble(sentenceType, content, att, Option.empty, Source("generated"))

  def Associativity = definition.Associativity

  def Att() = attributes.Att()

  def Sort(name: String): Sort = ADT.SortLookup(name)
  def Sort(name: String, moduleName: ModuleName): Sort = ADT.SortLookup(name, moduleName)

}
