module INPUT
  syntax Int {}
  syntax Var {}
  syntax Exp {}
  syntax {Sin, Sout} Sout ::= Sin [symbol(inj)]

  syntax Int{} ::= r"[0-9]+"   [token]
  syntax Var{} ::= r"[A-Z][a-zA-Z0-9]*" [token]
  
  syntax Exp{} ::= Int{}         [symbol(inj{Int{},Exp{}}), parsingOnly]
               | Var{}           [symbol(inj{Var{},Exp{}}), parsingOnly]
               | Exp{} "+" Exp{} [symbol(plus{})] 
               | Exp{} "*" Exp{} [symbol(times{})]

endmodule
