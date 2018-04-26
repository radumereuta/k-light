module TEST 
 syntax Stmt ::= Type Exp ";" [symbol(tstmt)]
 syntax Stmt ::= Exp ";" [symbol(stmt)]
 syntax Exp  ::= Int
 syntax Exp  ::= Var
 syntax Exp  ::= Exp ">>" Exp [symbol(rshift)]
 syntax Exp  ::= Exp "<" Exp [symbol(lt)]
 syntax Int  ::= r"[0-9]+"  
 syntax Type ::= r"[A-Z][A-Za-z0-9]*"
 // This is simplified, in a more realistic grammar
 // we would allow lists of types.
 syntax Type ::= Type "<" Type ">" [symbol(ptype)]
 syntax Var  ::= r"[A-Z][A-Za-z0-9]*"
endmodule 

input(Stmt): HashSet<HashSet<String>> Foo;
