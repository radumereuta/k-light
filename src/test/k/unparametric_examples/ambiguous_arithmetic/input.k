module INPUT
  syntax Int ::= r"[0-9]+"   [token]
  syntax Var ::= r"[A-Z][a-zA-Z0-9]*" [token]
  syntax Exp ::= Int         [symbol(inj)]
  syntax Exp ::= Var         [symbol(inj)]
  syntax Exp ::= Exp "+" Exp [symbol(plus)] 
  syntax Exp ::= Exp "*" Exp [symbol(times)]

  rule 1 [start(Int)]
  rule 1 [start(Exp)]
  rule 1+2 [start(Exp)]
  rule 1+2+3 [start(Exp)]
  rule 1+2*3 [start(Exp)]
endmodule 
