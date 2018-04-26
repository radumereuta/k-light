module TEST 
  syntax Exp ::= Exp "==" Exp [symbol(eq)]
  syntax Exp ::= Exp "<" Exp  [symbol(lt)]
  syntax Exp ::= Exp ">" Exp  [symbol(gt)]
  Syntax Exp  ::= Var
  syntax Stmt ::= Exp
  syntax Stmt ::= "if" Exp "then" Stmt [symbol(it)]
  syntax Stmt ::= "if" Exp "then" Stmt "else" Stmt [symbol(ite)]
  syntax Var   ::= r"[A-Za-z][A-Za-z0-9]*"

endmodule 

input(Stmt): if c1 == c2 then if c3 < c4 then s1 else s2
