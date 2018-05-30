require "kore.k"

module BUBBLE

  syntax Bubble ::= Bubble BubbleItem [token]
                  | BubbleItem        [token]
  syntax BubbleItem ::= r"[^ \t\n\r]+" [token, reject2("rule|axiom|syntax|endmodule")]

endmodule

module ATTRIBUTES
  imports BUILTIN

  syntax KEY        ::= r"[a-z][A-Za-z\\-0-9]*" [token]
  syntax TAGList    ::= TAGCONTENT              [token]
  syntax TAGCONTENT ::= TAGCONTENT TC
                      | TC
                      | ""
  syntax TC ::= r"[^\n\r\\(\\)\\\"]+"
              | "(" TAGCONTENT ")"

  syntax Attr ::= KEY                 [symbol(#TagSimple)]
                | KEY "(" TAGList ")" [symbol(#TagContent)]
                | KEY "(" KString ")" [symbol(#TagString)]
endmodule

// To be used for first-level parsing/pretty-printing of global KORE
// definitions, where the K terms are put in bubbles.  A similar, but
// larger OUTER module can be defined for arbitrary K definitions.
module OUTER-KORE
  imports BUILTIN
  imports BUBBLE
  imports ATTRIBUTES
  imports KORE

  syntax KDefinition   ::= KRequireList KModuleList [symbol(#KDefinition)]
  syntax KRequire      ::= "require" KString        [symbol(#KRequire)]

  syntax KRequireList  ::= ""                       [symbol(#emptyKRequireList)]
                         | KRequireList KRequire    [symbol(#KRequireList)]

  syntax KModule       ::= "module" KModuleName
                                    KImportList
                                    KSentenceList
                           "endmodule"              [symbol(#KModule)]
  syntax KModuleList   ::= ""                       [symbol(#emptyKModuleList)]
                         | KModuleList KModule      [symbol(#KModuleList)]

  syntax KImport       ::= "imports" KModuleName    [symbol(#KImport)]

  syntax KImportList   ::= ""                       [symbol(#emptyKImportList)]
                         | KImportList KImport      [symbol(#KImportList)]

  syntax KSentenceList ::= ""                       [symbol(#emptyKSentenceList)]
                         | KSentenceList KSentence  [symbol(#KSentenceList)]

  syntax KSentence ::= "syntax" KSort OptionalAttributes [symbol(#KSyntaxSort)]
                     | "syntax" KSort "::=" ProdBlock [symbol(#KSyntaxProduction)]
                     | "syntax" "{" KSortList "}" KSort "::=" ProdBlock [symbol(#KSyntaxProductionWParam)]

  syntax KProduction ::= KProductionItem
                       | KProduction KProductionItem [symbol(#KProduction)]
  syntax KProductionItem ::= KSort                   [symbol(#nonTerminal)]
                           | KString                 [symbol(#regularTermina)]
                           | "r" KString             [symbol(#regexTerminal)]

  syntax ProdBlock ::= ProdBlock "|" KProductionWAttr [symbol(#ProdBlock)]
                     | KProductionWAttr
  syntax KProductionWAttr ::= KProduction OptionalAttributes [symbol(#KProductionWAttr)]

  // We use #KAttributes as top symbol in the K term holding the attributes
  syntax OptionalAttributes ::= KAttributesDeclaration
                              | "" [symbol(#NoKAttributesDeclaration)]
  syntax KAttributesDeclaration ::= "[" AttrList "]" [symbol(#KAttributesDeclaration)]
  syntax AttrList ::= AttrList "," Attr [symbol(#KAttributesList)]
                    | Attr

  syntax KSentence ::= "axiom" "{" KSortList "}" AxiomContent "[" "]" [symbol(#KAxiomWParam)]
                     | "rule" Contents [symbol(#KRule)]
  syntax AxiomContent ::= Param [token]
  syntax Contents ::= Bubble                        [symbol(#NoAttrs)]
                    | Bubble KAttributesDeclaration [symbol(#Attrs), prefer]
  // The following can still change
  syntax KModuleName ::= r"[A-Z][A-Z\\-]*"    [token]

endmodule

module OUTER
  imports OUTER-KORE
  imports BUBBLE
  syntax Layout ::= r"(/\\*([^\\*]|(\\*+([^\\*/])))*\\*+/|//[^\n\r]*|[\\ \n\r\t])*"

endmodule
