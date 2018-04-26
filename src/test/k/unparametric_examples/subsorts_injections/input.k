/*
 * The difference between subsorts which have a klabel/symbol and those which have none.
 */
module INPUT
syntax Top ::= A1 | A2
syntax A1 ::= Var
syntax A2 ::= Var
syntax Var ::= r"[a-z]+"
// input: a
// output: #token("a", Var)
// Even though the parser explores multiple paths to reach the final result,
// they are eliminated due to equivalent results
endmodule
 
module INPUT2

syntax Top ::= A1 [klabel(Top2A1)] | A2 [klabel(Top2A2)]
syntax A1 ::= Var [klabel(A12Var)]
syntax A2 ::= Var [klabel(A22Var)]
syntax Var ::= r"[a-z]+"
// input: a
// output: amb(
//    Top2A1(A12Var(#token("a", Var))),
//    Top2A2(A22Var(#token("a", Var))))
// In this case all subsorts have a label and are present in the AST.
// This can be really useful when trying to infer the sort of variables.
endmodule
