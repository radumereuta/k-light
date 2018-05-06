module INPUT
  syntax Layout ::= r"([\\ \n\r\t])*" [token, klabel(tkLayout)]
  syntax Exp ::= Exp "==" Exp [klabel(eq)]
  syntax Exp ::= Exp "<" Exp  [klabel(lt)]
  syntax Exp ::= Exp ">" Exp  [klabel(gt)]
  syntax Exp  ::= Var         [klabel(inj)]
  syntax Stmt ::= Exp         [klabel(inj)]
  syntax Stmt ::= "if" Exp "then" Stmt [klabel(it)]
  syntax Stmt ::= "if" Exp "then" Stmt "else" Stmt [klabel(ite)]
  syntax Var   ::= r"[A-Za-z][A-Za-z0-9]*" [token, autoReject, klabel(tkVar)]
  rule if c1 == c2 then if c3 < c4 then s1 else s2 [start(Stmt)]
endmodule 
