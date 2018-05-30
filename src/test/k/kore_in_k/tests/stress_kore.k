// should parse and pass kore-parser

module TEST

syntax {Sin, Sout} Sout ::= Sin [symbol(inj{Sin,Sout})]
syntax {A} B{A} ::= "." A "," B{A} ";" [symbol(terminal{A})]
syntax {} C{} ::= "c" [symbol(c{})]
syntax C{}
syntax B{P}
syntax {A} A ::= B{C{}} [symbol(list{A})]

endmodule
