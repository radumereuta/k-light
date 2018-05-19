module INPUT
  syntax Layout ::= r"([\\ \n\r\t])*" [token]
  syntax Exp ::= Exp "==" Exp [symbol(eq)]
  syntax Exp ::= Exp "<" Exp  [symbol(lt)]
  syntax Exp ::= Exp ">" Exp  [symbol(gt)]
  syntax Exp  ::= Var         [symbol(inj)]
  syntax Stmt ::= Exp         [symbol(inj)]
  syntax Stmt ::= "if" Exp "then" Stmt [symbol(it)]
  syntax Stmt ::= "if" Exp "then" Stmt "else" Stmt [symbol(ite)]
  syntax Var   ::= r"[A-Za-z][A-Za-z0-9]*" [token, autoReject]
  rule if c1 == c2 then if c3 < c4 then s1 else s2 [start(Stmt)]
endmodule 
