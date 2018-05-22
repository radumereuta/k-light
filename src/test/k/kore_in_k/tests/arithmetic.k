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

endmodule
