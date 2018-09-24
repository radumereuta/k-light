// Copyright (c) 2015-2018 K Team. All Rights Reserved.
// written by Radu Mereuta
// This grammar is supposed to accept as input a full K definition
// which includes modules, syntax declarations and rules as bubbles.

module BUBBLE

  syntax Bubble ::= Bubble BubbleItem [token]
                  | BubbleItem        [token]
  syntax BubbleItem ::= r"[^ \t\n\r]+" [token, reject2("rule|syntax|endmodule|configuration|context")]

endmodule

module KSTRING
  syntax KString ::= r"[\\\"](([^\\\"\n\r\\\\])|([\\\\][nrtf\\\"\\\\])|([\\\\][x][0-9a-fA-F]{2})|([\\\\][u][0-9a-fA-F]{4})|([\\\\][U][0-9a-fA-F]{8}))*[\\\"]"      [token]
  // optionally qualified strings, like in Scala "abc", i"abc", r"a*bc", etc.
endmodule

module ATTRIBUTES
  imports KSTRING
  syntax KEY        ::= r"[a-z][A-Za-z\\-0-9]*" [token]
  syntax TAGList    ::= TAGCONTENT              [token]
  syntax TAGCONTENT ::= TAGCONTENT TC           [symbol(#TAGCONTENTList)] // dummy symbol
                      | TC                      [symbol(#TAGCONTENTTC)]   // dummy symbol
                      | ""                      [symbol(#NOTAGCONTENT)]   // dummy symbol
  syntax TC ::= r"[^\\n\\r\\(\\)\\\"]+"         [symbol('TC)]             // dummy symbol
              | "(" TAGCONTENT ")"

  syntax Attr ::= KEY                 [symbol(#TagSimple)]
                | KEY "(" TAGList ")" [symbol(#TagContent)]
                | KEY "(" KString ")" [symbol(#TagString)]
endmodule

// To be used for first-level parsing/pretty-printing of global KORE
// definitions, where the K terms are put in bubbles.  A similar, but
// larger OUTER module can be defined for arbitrary K definitions.
module SYNTAX-DECL
  imports KSTRING
  imports BUBBLE
  imports ATTRIBUTES

  syntax KDefinition   ::= KRequireList KModuleList [symbol(#KDefinition)]

  syntax KRequire      ::= "require" KString
                               [symbol(#KRequire)]

  syntax KRequireList  ::= ""  [symbol(#emptyKRequireList)]
                         | KRequireList KRequire
                               [symbol(#KRequireList), unit(#emptyKRequireList)]

  syntax KModule       ::= "module" KModuleName OptionalAttributes
                                    KImportList
                                    KSentenceList
                           "endmodule"
                               [symbol(#KModule)]
  syntax KModuleList   ::= ""  [symbol(#emptyKModuleList)]
                         | KModuleList KModule [symbol(#KModuleList), unit(#emptyKModuleList)]

  syntax KImport       ::= "imports" KModuleName [symbol(#KImport)]

  syntax KImportList   ::= ""  [symbol(#emptyKImportList)]
                         | KImportList KImport [symbol(#KImportList), unit(#emptyKImportList)]

  syntax KSentenceList ::= ""  [symbol(#emptyKSentenceList)]
                         | KSentenceList KSentence [symbol(#KSentenceList), unit(#kemptyKSentenceList)]

  syntax KSentence ::= "syntax" KSort OptionalAttributes [symbol(#KSyntaxSort)]
                     | "syntax" KSort "::=" PrioritySeqBlock [symbol(#KSyntaxProduction)]
                     | "syntax" "priority"   KPrioritySeq OptionalAttributes [symbol(#KSyntaxPriority)]
                     | "syntax" "priorities" KPrioritySeq OptionalAttributes [symbol(#KSyntaxPriorities)]
                     | "syntax" "left" KNeTagSet OptionalAttributes [symbol(#KSyntaxLeft)]
                     | "syntax" "right" KNeTagSet OptionalAttributes [symbol(#KSyntaxRight)]
                     | "syntax" "non-assoc" KNeTagSet OptionalAttributes [symbol(#KSyntaxNonAssoc)]

  syntax KPrioritySeq ::= KPrioritySeq ">" KNeTagSet   [symbol(#KPrioritySeq)]
                        | KNeTagSet
  syntax KNeTagSet    ::= Tag KNeTagSet                [symbol(#KTagSet)]
                        | Tag
  syntax Tag ::= r"[a-z][A-Za-z0-9\\-]*" [token]

  syntax KProduction ::= KProductionItem
                       | KProduction KProductionItem [symbol(#KProduction), unit(#emptyKProduction)]
  syntax KProductionItem ::= KSort       [symbol(#NonTerminal)]
                           | KString     [symbol(#Terminal)]
                           | "r" KString [symbol(#RegexTerminal)]
                           | "NeList" "{" KSort "," KString "}" [symbol(#NeList)]
                           |   "List" "{" KSort "," KString "}" [symbol(#List)]
  syntax TokenContent ::= r"[^\\n\\r}]" [token]
  syntax PrioritySeqBlock ::= PrioritySeqBlock ">" AssocAttribute ProdBlock [symbol(#PrioritySeqBlock)]
                            | ProdBlock
  syntax AssocAttribute ::= ""           [symbol(#NoAttribute)]
                          | "left:"      [symbol(#LeftAttribute)]
                          | "right:"     [symbol(#RightAttribute)]
                          | "non-assoc:" [symbol(#NonAssocAttribute)]
  syntax ProdBlock ::= ProdBlock "|" KProductionWAttr [symbol(#ProdBlock)]
                     | KProductionWAttr
  syntax KProductionWAttr ::= KProduction OptionalAttributes [symbol(#KProductionWAttr)]
                            | Tag "(" KSortList ")" OptionalAttributes [symbol(#KFuncProductionWAttr)]
                            |     "(" KSortList ")" OptionalAttributes [symbol(#KTupleProductionWAttr)]
  syntax KSortList ::= KSortList "," KSort [symbol(#KSortList)]
                     | KSort
  // We use #KAttributes as top symbol in the K term holding the attributes
  syntax OptionalAttributes ::= KAttributesDeclaration
                              | "" [symbol(#NoKAttributesDeclaration)]
  syntax KAttributesDeclaration ::= "[" AttrList "]" [symbol(#KAttributesDeclaration)]
  syntax AttrList ::= AttrList "," Attr [symbol(#KAttributesList)]
                    | Attr

  syntax KSentence ::= "configuration" Contents [symbol(#KConfiguration)]
                     | "rule"    Contents [symbol(#KRule)]
                     | "context" Contents [symbol(#KContext)]
  syntax Contents ::= Bubble                        [symbol(#NoAttrs)]
                    | Bubble KAttributesDeclaration [symbol(#Attrs), prefer]
  // The following can still change
  syntax KModuleName ::= r"[A-Z][A-Z\\-]*"    [token]
  syntax KSort       ::= r"[A-Z][A-Za-z0-9]*" [token]
endmodule


module OUTER-K
  imports SYNTAX-DECL
  imports BUBBLE

  syntax Layout ::= r"(/\\*([^\\*]|(\\*+([^\\*/])))*\\*+/|//[^\n\r]*|[\\ \n\r\t])*"

endmodule
