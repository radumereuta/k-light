module INPUT
 syntax Int ::= r"[+-]?[0-9]+"   [token2, klabel(tkInt)]
 syntax Exp ::= Exp "+" Exp [klabel(plus)] 
 syntax Exp ::= Exp Exp     [klabel(app)]
 syntax Exp ::= Int         [klabel(inj)]
 rule 1 [start(Int)]
 rule 1 [start(Exp)]
 rule +1 [start(Exp)]
 rule -1 [start(Exp)]
 rule 1+2 [start(Exp)]
 rule 1++2 [start(Exp)]
endmodule 
