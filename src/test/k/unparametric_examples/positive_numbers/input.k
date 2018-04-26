module TEST 
 syntax Int ::= r"[+-]?[0-9]+"  
 syntax Exp ::= Exp "+" Exp [symbol(plus)] 
 syntax Exp ::= Exp Exp [symbol(app)]
 syntax Exp ::= Int 
endmodule 

input(Int): 1
input(Exp): 1
input(Exp): +1
input(Exp): -1
input(Exp): 1+2
input(Exp): 1++2
