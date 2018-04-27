module INPUT
 syntax #Layout ::= r"([\\ \n\r\t])*" [token]
 syntax Stmt ::= Type Exp ";" [klabel(tstmt)]
 syntax Stmt ::= Exp ";"      [klabel(stmt)]
 syntax Exp  ::= Int          [klabel(inj)]
 syntax Exp  ::= Var          [klabel(inj)]
 syntax Exp  ::= Exp ">>" Exp [klabel(rshift)]
 syntax Exp  ::= Exp "<" Exp  [klabel(lt)]
 syntax Int  ::= r"[0-9]+"    [token]
 syntax Type ::= r"[A-Z][A-Za-z0-9]*" [token]
 // This is simplified, in a more realistic grammar
 // we would allow lists of types.
 syntax Type ::= Type "<" Type ">" [klabel(ptype)]
 syntax Var  ::= r"[A-Z][A-Za-z0-9]*" [token]
 rule HashSet<HashSet<String>> Foo; [start(Stmt)]
endmodule 
