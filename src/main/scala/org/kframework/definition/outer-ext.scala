// Copyright (c) 2014 K Team. All Rights Reserved.

package org.kframework.definition

import org.kframework.attributes._

case class Bubble(sentenceType: String, contents: String, att: Att = Att(), location: Option[Location], source: Source) extends SemanticSentence
