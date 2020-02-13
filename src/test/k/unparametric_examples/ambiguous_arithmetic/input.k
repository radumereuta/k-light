module INPUT
  syntax Int ::= r"[0-9]+"   [token]
  syntax Var ::= r"[A-Z][a-zA-Z0-9]*" [token]
  syntax Exp ::= Int         [klabel(inj)]
  syntax Exp ::= Var         [klabel(inj)]
  syntax Exp ::= Exp "+" Exp [klabel(plus)] 
  syntax Exp ::= Exp "*" Exp [klabel(times)]

  rule 1 [start(Int)]
  rule 1 [start(Exp)]
  rule 1+2 [start(Exp)]
  rule 1+2+3 [start(Exp)]
  rule 1+2*3 [start(Exp)]
endmodule 
