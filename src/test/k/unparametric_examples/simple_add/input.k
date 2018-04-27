module INPUT
 syntax Int ::= r"[0-9]+"   [token]
 syntax Exp ::= Exp "+" Exp [klabel(plus)]
 syntax Exp ::= Int         [klabel(inj)]
 rule 1 [start(Int)]
 rule 1 [start(Exp)]
 rule 1+2 [start(Exp)]
 rule 1+2+3 [start(Exp)]
endmodule
