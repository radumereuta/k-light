module BUBBLE

  syntax Bubble ::= Bubble BubbleItem [token]
                  | BubbleItem        [token]
  syntax BubbleItem ::= r"[^ \t\n\r]+" [token, reject("rule|syntax|endmodule|configuration|context")]

endmodule

module KSTRING
  syntax KString ::= r"[\\\"](([^\\\"\n\r\\\\])|([\\\\][nrtf\\\"\\\\])|([\\\\][x][0-9a-fA-F]{2})|([\\\\][u][0-9a-fA-F]{4})|([\\\\][U][0-9a-fA-F]{8}))*[\\\"]" [token]
endmodule

module ATTRIBUTES
  imports KSTRING

  syntax KEY        ::= r"[a-z][A-Za-z\\-0-9]*" [token]
  syntax TAGList    ::= TAGCONTENT              [token]
  syntax TAGCONTENT ::= TAGCONTENT TC
                      | TC
                      | ""
  syntax TC ::= r"[^\n\r\\(\\)\\\"]+"
              | "(" TAGCONTENT ")"

  syntax Attr ::= KEY                 [klabel(#TagSimple)]
                | KEY "(" TAGList ")" [klabel(#TagContent)]
                | KEY "(" KString ")" [klabel(#TagString)]
endmodule

// To be used for first-level parsing/pretty-printing of global KORE
// definitions, where the K terms are put in bubbles.  A similar, but
// larger OUTER module can be defined for arbitrary K definitions.
module OUTER-KORE
  imports KSTRING
  imports BUBBLE
  imports ATTRIBUTES

  syntax KDefinition   ::= KRequireList KModuleList [klabel(#KDefinition)]
  syntax KRequire      ::= "require" KString        [klabel(#KRequire)]

  syntax KRequireList  ::= ""                       [klabel(#emptyKRequireList)]
                         | KRequireList KRequire    [klabel(#KRequireList)]

  syntax KModule       ::= "module" KModuleName
                                    KImportList
                                    KSentenceList
                           "endmodule"              [klabel(#KModule)]
  syntax KModuleList   ::= ""                       [klabel(#emptyKModuleList)]
                         | KModuleList KModule      [klabel(#KModuleList)]

  syntax KImport       ::= "imports" KModuleName    [klabel(#KImport)]

  syntax KImportList   ::= ""                       [klabel(#emptyKImportList)]
                         | KImportList KImport      [klabel(#KImportList)]

  syntax KSentenceList ::= ""                       [klabel(#emptyKSentenceList)]
                         | KSentenceList KSentence  [klabel(#KSentenceList)]

  syntax KSentence ::= "syntax" KSort OptionalAttributes [klabel(#KSyntaxSort)]
                     | "syntax" KSort "::=" ProdBlock [klabel(#KSyntaxProduction)]
                     | "syntax" "{" KSortList "}" KSort "::=" ProdBlock [klabel(#KSyntaxProductionWParam)]

  syntax KProduction ::= KProductionItem
                       | KProduction KProductionItem [klabel(#KProduction)]
  syntax KProductionItem ::= KSort
                           | KString
                           | "r" KString             [klabel(#regexToken)]

  syntax ProdBlock ::= ProdBlock "|" KProductionWAttr [klabel(#ProdBlock)]
                     | KProductionWAttr
  syntax KProductionWAttr ::= KProduction OptionalAttributes [klabel(#KProductionWAttr)]

  // We use #KAttributes as top KLabel in the K term holding the attributes
  syntax OptionalAttributes ::= KAttributesDeclaration
                              | "" [klabel(#NoKAttributesDeclaration)]
  syntax KAttributesDeclaration ::= "[" AttrList "]" [klabel(#KAttributesDeclaration)]
  syntax AttrList ::= AttrList "," Attr [klabel(#KAttributesList)]
                    | Attr

  syntax KSentence ::= "configuration" Contents [klabel(#KConfiguration)]
                     | "rule"    Contents [klabel(#KRule)]
                     | "context" Contents [klabel(#KContext)]
  syntax Contents ::= Bubble                        [klabel(#NoAttrs)]
                    | Bubble KAttributesDeclaration [klabel(#Attrs), prefer]
  // The following can still change
  syntax KModuleName ::= r"[A-Z][A-Z\\-]*"    [token]
  syntax KSort       ::= r"[#]?[A-Z][A-Za-z0-9]*" [token]
                       | KSort "{" KSortList "}"  [klabel(#paramSort)]
  syntax KSortList   ::= KSortList "," KSort  [klabel(#KSortList)]
                       | KSort
                       | ""                   [klabel(#emptyKSortList)]
endmodule

module OUTER
  imports OUTER-KORE
  imports BUBBLE
  syntax Layout ::= r"(/\\*([^\\*]|(\\*+([^\\*/])))*\\*+/|//[^\n\r]*|[\\ \n\r\t])*"

endmodule
