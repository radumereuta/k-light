module TEST

syntax S{}
syntax S{} ::= "" [symbol(smb{})]

syntax {Sin, Sout} Sout ::= Sin [symbol(inj{Sin,Sout})]

endmodule
