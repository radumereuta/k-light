module INPUT
 syntax Layout ::= r"([\\ \n\r\t])*" [token]
 syntax Stmt ::= Type Exp ";" [symbol(tstmt)]
 syntax Stmt ::= Exp ";"      [symbol(stmt)]
 syntax Exp  ::= Int          [symbol(inj)]
 syntax Exp  ::= Var          [symbol(inj)]
 syntax Exp  ::= Exp ">>" Exp [symbol(rshift)]
 syntax Exp  ::= Exp "<" Exp  [symbol(lt)]
 syntax Int  ::= r"[0-9]+"    [token]
 syntax Type ::= r"[A-Z][A-Za-z0-9]*" [token]
 // This is simplified, in a more realistic grammar
 // we would allow lists of types.
 syntax Type ::= Type "<" Type ">" [symbol(ptype)]
 syntax Var  ::= r"[A-Z][A-Za-z0-9]*" [token]
 rule HashSet<HashSet<String>> Foo; [start(Stmt)]
endmodule 
