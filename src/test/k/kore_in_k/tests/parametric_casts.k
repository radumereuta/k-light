module BUILTIN
  syntax KString{}
  syntax KSort{}
  syntax KString{} ::= r"[\\\"](([^\\\"\n\r\\\\])|([\\\\][nrtf\\\"\\\\])|([\\\\][x][0-9a-fA-F]{2})|([\\\\][u][0-9a-fA-F]{4})|([\\\\][U][0-9a-fA-F]{8}))*[\\\"]" [token]
  syntax KSort{}     ::= r"[#]?[A-Z][A-Za-z0-9]*" [token]
                       | KSort{} "{" KSortList{} "}"  [symbol(paramSort{})]
  syntax KSortList{}
  syntax KSortList{} ::= KSortList{} "," KSort{}  [symbol(ksortList{})]
                       | KSort{}
                       | ""                   [symbol(emptyKSortList{})]
endmodule

module KORE 
imports BUILTIN

syntax VarName{}
syntax VarName{} ::= r"[a-zA-Z][a-zA-Z0-9]*" [token]

syntax Param{}
syntax Param{} ::= KString{}
               | VarName{} ":" KSort{} [symbol(var{})]
               | SymbolName{} "{" KSortList{} "}" "(" ParamList{} ")" [symbol(symbolDecl{})]

syntax ParamList{}
syntax ParamList{} ::= "" [symbol(empty{})]
                     | NeParamList{}
syntax NeParamList{}
syntax NeParamList{} ::= Param{}
                       | Param{} "," NeParamList{} [symbol(paramList{})]
syntax SymbolName{}
syntax SymbolName{} ::= r"[\\\\]?[a-z][a-zA-Z0-9\\-']*" [token]

endmodule

module TEST
imports KORE

syntax Exp{}
syntax Stmt{}
syntax TopSort{}
syntax BottomSort{}
syntax {S} Stmt{} ::= "if" Exp{} "then" S "else" S [symbol(ite{S})]
syntax BottomSort{} ::= "{" KSortList{} "}:(" TopSort{} ")" [symbol(cast{})]


axiom {S} ite{S}(A:Exp{}, S1:S, S2:S) []

endmodule
