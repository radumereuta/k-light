module TEST 
 syntax Int ::= r"[0-9]+"  
 syntax Var ::= r"[A-Z][a-zA-Z0-9]*" 
 syntax Exp ::= Int
 syntax Exp ::= Var 
 syntax Exp ::= Exp "+" Exp [symbol(plus)] 
 syntax Exp ::= Exp "*" Exp [symbol(times)]
endmodule 

input(Int): 1
input(Exp): 1
input(Exp): 1+2
input(Exp): 1+2+3
input(Exp): 1+2*3+VAR
