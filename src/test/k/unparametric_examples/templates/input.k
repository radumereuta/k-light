module INPUT
 syntax Layout ::= r"([\\ \n\r\t])*" [token, klabel(tkLayout)]
 syntax Stmt ::= Type Exp ";" [klabel(tstmt)]
 syntax Stmt ::= Exp ";"      [klabel(stmt)]
 syntax Exp  ::= Int          [klabel(inj)]
 syntax Exp  ::= Var          [klabel(inj)]
 syntax Exp  ::= Exp ">>" Exp [klabel(rshift)]
 syntax Exp  ::= Exp "<" Exp  [klabel(lt)]
 syntax Int  ::= r"[0-9]+"    [token, klabel(tkInt)]
 syntax Type ::= r"[A-Z][A-Za-z0-9]*" [token, klabel(tkType)]
 // This is simplified, in a more realistic grammar
 // we would allow lists of types.
 syntax Type ::= Type "<" Type ">" [klabel(ptype)]
 syntax Var  ::= r"[A-Z][A-Za-z0-9]*" [token, klabel(tkVar)]
 rule HashSet<HashSet<String>> Foo; [start(Stmt)]
endmodule 
