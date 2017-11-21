package org.kframework.frontend

import org.kframework.definition._
import org.kframework.frontend

/**
  * Abstract Data Types: basic implementations for the inner KORE interfaces.
  *
  * Tools using inner KORE data structures can either use these classes directly or have their own implementations.
  */


object ADT {

  object SortLookup {
    def apply(s: String): SortLookup = {
      s.count(_ == '@') match {
        case 0 => SortLookup(s, ModuleName.STAR)
        case 1 =>
          val ssplit = s.split("@")
          SortLookup(ssplit(0), ModuleName(ssplit(1)))
        case 2 => throw new AssertionError("Sort name contains multiple @s")
      }
    }
  }

  case class SortLookup(localName: String, moduleName: ModuleName) extends frontend.Sort with LookupSymbol {
    override def toString = name

    override def equals(other: Any) = other match {
      case s: Sort if this.moduleName == ModuleName.STAR => s.localName == this.localName
      case s: frontend.Sort => this.moduleName == s.moduleName && this.localName == s.localName
      case _ => throw new AssertionError("We cannot compare this.")
    }

    override def name = super[LookupSymbol].name // hack for compiler bug
  }

  case class Sort(localName: String, moduleName: ModuleName) extends frontend.Sort with ResolvedSymbol {
    override def toString = name
    assert(moduleName != ModuleName.STAR)

    override def equals(other: Any) = other match {
      case s: SortLookup if s.moduleName == ModuleName.STAR => this.localName == s.localName
      case s: frontend.Sort => s.moduleName == this.moduleName && s.localName == this.localName
      case _ => throw new AssertionError("We cannot compare " + other + " to " + this)
    }

    override def name = super[ResolvedSymbol].name // hack for compiler bug
  }
}
