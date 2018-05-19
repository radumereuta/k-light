module TEST

syntax {Sin, Sout} Sout ::= Sin [symbol(inj)] // the first thing that came to mind
let Sin, Sout in Sout ::= Sin [symbol(inj2)]  // syntax proposed by @dlucanu
syntax {A} B{A} ::= "." A "," B{A} ";" [symbol(terminal)]
syntax {} C ::= "c" [symbol(c)]
syntax #A ::= B{C} [symbol(inj{B{C},#A})]

endmodule
