/*
 * Problem: both inputs parse without any issue,
 * but the user may expect the space between `int` and `x` to be required.
 */
module INPUT

syntax Decl ::= Type Exp ";"
syntax Type ::= "int" | "double"
syntax Exp  ::= Int | Id
syntax Id   ::= r"[\\_a-zA-Z][\\_a-zA-Z0-9]*"                     // with problems
syntax Id   ::= r"(?<![A-Za-z0-9\\_])[A-Za-z\\_][A-Za-z0-9\\_]*"  // precede restriction ensures a delimiter before Id


endmodule

// input: intx;  // should fail but does not without lexical restrictions
// input: int x;
