// Copyright (c) 2015-2018 K Team. All Rights Reserved.
// written by Radu Mereuta
// This grammar is supposed to accept as input a full K definition
// which includes modules, syntax declarations and rules as bubbles.

module BUBBLE

  syntax Bubble 
endmodule

module ATTRIBUTES
  imports KSTRING
  syntax KEY
  syntax TAGList

  syntax Attr ::= KEY                 [klabel(tagSimple)]
                | KEY "(" TAGList ")" [klabel(tagContent)]
                | KEY "(" KString ")" [klabel(tagString)]
endmodule

// To be used for first-level parsing/pretty-printing of global KORE
// definitions, where the K terms are put in bubbles.  A similar, but
// larger OUTER module can be defined for arbitrary K definitions.
module SYNTAX-DECL
  imports KSTRING
  imports BUBBLE
  imports ATTRIBUTES

  syntax KDefinition   ::= KRequireList KModuleList [klabel(kDefinition)]

  syntax KRequire      ::= "require" KString
                               [klabel(kRequire)]

  syntax KRequireList  ::= ""  [klabel(emptyKRequireList)]
                         | KRequireList KRequire
                               [klabel(KRequireList), unit(emptyKRequireList)]

  syntax KModule       ::= "module" KModuleName OptionalAttributes
                                    KImportList
                                    KSentenceList
                           "endmodule"
                               [klabel(kModule)]
  syntax KModuleList   ::= ""  [klabel(emptyKModuleList)]
                         | KModuleList KModule [klabel(kModuleList), unit(emptyKModuleList)]

  syntax KImport       ::= "imports" KModuleName [klabel(kImport)]

  syntax KImportList   ::= ""  [klabel(emptyKImportList)]
                         | KImportList KImport [klabel(kImportList), unit(emptyKImportList)]

  syntax KSentenceList ::= ""  [klabel(emptyKSentenceList)]
                         | KSentenceList KSentence [klabel(kSentenceList), unit(kemptyKSentenceList)]

  syntax KSentence ::= "syntax" KSort OptionalAttributes [klabel(kSyntaxSort)]
                     | "syntax" KSort "::=" PrioritySeqBlock [klabel(kSyntaxProduction)]
                     | "syntax" "priority"   KPrioritySeq OptionalAttributes [klabel(kSyntaxPriority)]
                     | "syntax" "priorities" KPrioritySeq OptionalAttributes [klabel(kSyntaxPriorities)]
                     | "syntax" "left" KNeTagSet OptionalAttributes [klabel(kSyntaxLeft)]
                     | "syntax" "right" KNeTagSet OptionalAttributes [klabel(kSyntaxRight)]
                     | "syntax" "non-assoc" KNeTagSet OptionalAttributes [klabel(kSyntaxNonAssoc)]

  syntax KPrioritySeq ::= KPrioritySeq ">" KNeTagSet   [klabel(kPrioritySeq)]
                        | KNeTagSet
  syntax KNeTagSet    ::= Tag KNeTagSet                [klabel(kTagSet)]
                        | Tag
  syntax Tag

  syntax KProduction ::= KProductionItem
                       | KProduction KProductionItem [klabel(kProduction), unit(emptyKProduction)]
  syntax KProductionItem ::= KSort       [klabel(nonTerminal)]
                           | KString     [klabel(terminal)]
                           | "r" KString [klabel(regexTerminal)]
                           | "NeList" "{" KSort "," KString "}" [klabel(neListProd)]
                           |   "List" "{" KSort "," KString "}" [klabel(listProd)]
  syntax PrioritySeqBlock ::= PrioritySeqBlock ">" AssocAttribute ProdBlock [klabel(prioritySeqBlock)]
                            | ProdBlock
  syntax AssocAttribute ::= ""           [klabel(noAttribute)]
                          | "left:"      [klabel(leftAttribute)]
                          | "right:"     [klabel(rightAttribute)]
                          | "non-assoc:" [klabel(nonAssocAttribute)]
  syntax ProdBlock ::= ProdBlock "|" KProductionWAttr [klabel(prodBlock)]
                     | KProductionWAttr
  syntax KProductionWAttr ::= KProduction OptionalAttributes [klabel(kProductionWAttr)]
                            | Tag "(" KSortList ")" OptionalAttributes [klabel(kFuncProductionWAttr)]
                            |     "(" KSortList ")" OptionalAttributes [klabel(kTupleProductionWAttr)]
  syntax KSortList ::= KSortList "," KSort [klabel(kSortList)]
                     | KSort
  // We use KAttributes as top symbol in the K term holding the attributes
  syntax OptionalAttributes ::= KAttributesDeclaration
                              | "" [klabel(noKAttributesDeclaration)]
  syntax KAttributesDeclaration ::= "[" AttrList "]" [klabel(kAttributesDeclaration)]
  syntax AttrList ::= AttrList "," Attr [klabel(kAttributesList)]
                    | Attr

  syntax KSentence ::= "configuration" Contents [klabel(kConfiguration)]
                     | "rule"    Contents [klabel(kRule)]
                     | "context" Contents [klabel(kContext)]
  syntax Contents ::= Bubble                        [klabel(noAttrs)]
                    | Bubble KAttributesDeclaration [klabel(attrs), prefer]
  // The following can still change
  syntax KModuleName
  syntax KSort
endmodule


module OUTER-K5
  imports SYNTAX-DECL
  imports BUBBLE

  configuration <k> $PGM:KDefinition </k>

endmodule
