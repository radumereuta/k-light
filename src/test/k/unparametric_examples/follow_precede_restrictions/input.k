/*
 * Problem: both inputs parse without any issue,
 * but the user may expect the space between `int` and `x` to be required.
 */
module COMMON
syntax Layout ::= r"([\\ \n\r\t])*" [token]
syntax Decl ::= Type Exp ";" [klabel(typeDecl)]
syntax Type ::= "int" [klabel(intType)] | "double" [klabel(doubleType)]
syntax Id
syntax Exp  ::= Id [klabel(inj)]
endmodule

module INPUT
import COMMON
syntax Id   ::= r"[\\_a-zA-Z][\\_a-zA-Z0-9]*"                    [token] // with problems
rule intx; [start(Decl)]           // TODO: try to figure out why only one axiom gets printed
rule int x; [start(Decl)]
endmodule

module INPUT2
import COMMON
syntax Id   ::= r"(?<![A-Za-z0-9\\_])[A-Za-z\\_][A-Za-z0-9\\_]*"  [token] // precede restriction ensures a delimiter before Id
rule intx; [start(Decl)]
rule int x; [start(Decl)]
endmodule

// input: intx;  // should fail but does not without lexical restrictions
// input: int x;
