package org.kframework.frontend

import org.kframework.definition.ModuleQualified


import collection.JavaConverters._

/**
 * This file contains all inner KORE interfaces.
 * The the wiki for documentation:
 * https://github.com/kframework/k/wiki/KORE-data-structures-guide
 */

trait HashCodeCaching {
  lazy val cachedHashCode = computeHashCode

  override def hashCode = cachedHashCode

  def computeHashCode: Int
}

trait Sort extends ModuleQualified with HashCodeCaching {
  def name: String
  override def equals(other: Any) = other match {
    case other: Sort => name == other.name
    case _ => false
  }
  override def computeHashCode: Int = localName.hashCode

}
abstract class AbstractSort extends Sort

