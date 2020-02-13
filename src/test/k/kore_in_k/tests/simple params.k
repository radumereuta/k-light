module TEST

syntax {Sin, Sout} Sout ::= Sin [klabel(inj)] // the first thing that came to mind
let Sin, Sout in Sout ::= Sin [klabel(inj2)]  // syntax proposed by @dlucanu
syntax {A} B{A} ::= "." A "," B{A} ";" [klabel(terminal)]
syntax {} C ::= "c" [klabel(c)]
syntax #A ::= B{C} [klabel(inj{B{C},#A})]

endmodule
