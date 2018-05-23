module PREDEF
  syntax {Sin, Sout} Sout ::= Sin [symbol(inj{Sin,Sout})]
endmodule

module INPUT
  imports PREDEF
  syntax Int {}
  syntax Var {}
  syntax Exp {}

  syntax Int{} ::= r"[0-9]+"            [token]
  syntax Var{} ::= r"[A-Z][a-zA-Z0-9]*" [token]

  syntax Exp{} ::= Int{}           [symbol(inj{Int{},Exp{}}), parsingOnly]
  syntax Exp{} ::= Var{}           [symbol(inj{Var{},Exp{}}), parsingOnly]
  syntax Exp{} ::= Exp{} "+" Exp{} [symbol(plus{})]
  syntax Exp{} ::= Exp{} "*" Exp{} [symbol(times{})]

  axiom {} \dv{Int{}}("1") []
  axiom {} \dv{Int{}}("1") []
axiom {} 
\exists{Exp{}}(V2:Exp{},
\exists{Exp{}}(V1:Exp{},
\exists{Exp{}}(V0:Exp{},
    \and{Exp{}}(
        \equals{Exp{},Exp{}}(V2:Exp{},inj{Int{},Exp{}}(\dv{Int{}}("3"))),
    \and{Exp{}}(
        \equals{Exp{},Exp{}}(V1:Exp{},inj{Int{},Exp{}}(\dv{Int{}}("2"))),
    \and{Exp{}}(
        \equals{Exp{},Exp{}}(V0:Exp{},inj{Int{},Exp{}}(\dv{Int{}}("1"))),
\or{Exp{}}(plus{}(V0:Exp{},times{}(V1:Exp{},V2:Exp{})),\or{Exp{}}(times{}(plus{}(V0:Exp{},V1:Exp{}),V2:Exp{}),\bottom{Exp{}}())))))))) []

endmodule
