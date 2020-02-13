module BUILTIN
  syntax KString ::= r"[\\\"](([^\\\"\n\r\\\\])|([\\\\][nrtf\\\"\\\\])|([\\\\][x][0-9a-fA-F]{2})|([\\\\][u][0-9a-fA-F]{4})|([\\\\][U][0-9a-fA-F]{8}))*[\\\"]" [token]
  syntax KSort       ::= r"[#]?[A-Z][A-Za-z0-9]*" [token]
                       | KSort "{" KSortList "}"  [symbol(#paramSort)]
  syntax KSortList   ::= KSortList "," KSort  [klabel(#KSortList)]
                       | KSort
                       | ""                   [klabel(#emptyKSortList)]
endmodule

module KORE
imports BUILTIN

syntax VarName ::= r"[a-zA-Z][a-zA-Z0-9]*" [token]

syntax Param ::= KString
               | VarName ":" KSort [symbol(var)]
               | SymbolName "{" KSortList "}" "(" ParamList ")" [klabel(#symbolDecl)]

syntax ParamList ::= "" [symbol(empty)]
                 | NeParamList
syntax NeParamList ::= Param
                   | Param "," NeParamList [klabel(#paramList)]
syntax SymbolName ::= r"[\\\\]?[a-z][a-zA-Z0-9\\-']*" [token]

endmodule
