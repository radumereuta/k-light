module TEST

syntax {Sin, Sout} Sout ::= Sin [klabel(inj)]
syntax {A} B{A} ::= "." [klabel(terminal)]
syntax {} C ::= "c" [klabel(c)]
syntax A ::= B{A}

endmodule
