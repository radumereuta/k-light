module TEST

syntax {Sin, Sout} Sout ::= Sin [symbol(inj)]
syntax {A} B{A} ::= "." A "," B{A} ";" [symbol(terminal)]
syntax {} C ::= "c" [symbol(c)]
syntax #A ::= B{C} [symbol(inj{B{C},#A})]

endmodule
