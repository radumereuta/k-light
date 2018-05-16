module TEST

syntax {Sin, Sout} Sout ::= Sin [klabel(inj)]
let Sin, Sout in Sout ::= Sin [klabel(inj2)]
syntax {A} B{A} ::= "." A "," B{A} ";" [klabel(terminal)]
syntax {} C ::= "c" [klabel(c)]
syntax #A ::= B{C} [klabel(inj{B{C},#A})]

endmodule
