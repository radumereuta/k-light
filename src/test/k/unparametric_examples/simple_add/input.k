module INPUT
 syntax Int ::= r"[0-9]+"   [token]
 syntax Exp ::= Exp "+" Exp [symbol(plus)]
 syntax Exp ::= Int         [symbol(inj)]
 rule 1 [start(Int)]
 rule 1 [start(Exp)]
 rule 1+2 [start(Exp)]
 rule 1+2+3 [start(Exp)]
endmodule
