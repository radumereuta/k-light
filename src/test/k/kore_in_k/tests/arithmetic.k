module INPUT
  syntax Int {}
  syntax Var {}
  syntax Exp {}
  syntax {Sin, Sout} Sout ::= Sin [klabel(inj)]

  syntax Int{} ::= r"[0-9]+"   [token]
  syntax Var{} ::= r"[A-Z][a-zA-Z0-9]*" [token]
  
  syntax Exp{} ::= Int{}         [klabel(inj{Int{},Exp{}}), parsingOnly]
               | Var{}           [klabel(inj{Var{},Exp{}}), parsingOnly]
               | Exp{} "+" Exp{} [klabel(plus{})] 
               | Exp{} "*" Exp{} [klabel(times{})]

endmodule
