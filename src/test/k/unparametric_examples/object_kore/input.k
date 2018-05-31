module BUILTIN
  syntax KString
  syntax KSort
  syntax KString ::= r"[\\\"](([^\\\"\n\r\\\\])|([\\\\][nrtf\\\"\\\\])|([\\\\][x][0-9a-fA-F]{2})|([\\\\][u][0-9a-fA-F]{4})|([\\\\][U][0-9a-fA-F]{8}))*[\\\"]" [token]
  syntax KSort   ::= r"[#]?[A-Z][A-Za-z0-9]*" [token]
                   | KSort "{" KSortList "}"  [symbol(paramSort)]
  syntax KSortList
  syntax KSortList ::= KSortList "," KSort  [symbol(ksortList)]
                     | KSort
                     | ""                   [symbol(emptyKSortList)]
endmodule

module KORE 
imports BUILTIN

syntax VarName ::= r"[a-zA-Z][a-zA-Z0-9]*" [token]
syntax Variable ::= VarName ":" KSort [symbol(var)]
syntax Param ::= KString
               | Variable
               | SymbolName "{" KSortList "}" "(" ParamList ")" [symbol(symbolDecl)]

syntax ParamList ::= "" [symbol(empty)]
                   | NeParamList
syntax NeParamList ::= Param
                     | Param "," NeParamList [symbol(paramList)]
syntax SymbolName ::= r"[\\\\]?[a-z][a-zA-Z0-9\\-']*" [token]

endmodule

module INPUT
imports KORE

syntax Exp  ::= BottomSort
syntax Stmt ::= BottomSort
syntax TopSort ::= BottomSort

//syntax {S} Stmt ::= "if" Exp "then" S "else" S [symbol(ite)]
syntax Stmt ::= "if" Exp "then" TopSort "else" TopSort [symbol(ite)]
              | "skip" [symbol(skip)]
syntax BottomSort ::= "{" KSortList "}:(" TopSort ")" [symbol(cast)]
syntax TopSort ::= Stmt | Exp
syntax BottomSort ::= Variable

syntax Layout ::= r"(/\\*([^\\*]|(\\*+([^\\*/])))*\\*+/|//[^\n\r]*|[\\ \n\r\t])*"


rule {Stmt}:(if A:Exp then skip else skip) [start(TopSort)]

endmodule
