/*
 * A typical lookup rule where we rewrite from Id to Int.
 * The question is whether we need overloaded rewrites to express such
 * rules or use a generic production that takes K (the top sort).
 */
module INPUT
syntax Exp ::= Int [klabel(Exp2Int)] | Id [klabel(Exp2Id)]
syntax K   ::= K   "=>" K
syntax Exp ::= Exp "=>" Exp
syntax Int ::= Int "=>" Int
syntax Id  ::= Id  "=>" Id
// omitted subsorts to K and cell productions


rule <k> A => B </k>        <env> A |-> B </env>
rule <k> A:Id => B:Int </k> <env> A |-> B </env>
rule <k> A => B </k>        <env> A:Id |-> B:Int </env>

/*
amb(
    rewK(
        amb(A, Exp2Id(A), Exp2Int(A)),
        amb(B, Exp2Id(B), Exp2Int(B))),
    rewExp(
        amb(A, Exp2Id(A), Exp2Int(A)),
        amb(B, Exp2Id(B), Exp2Int(B))),
    rewId(A, B),
    rewInt(A, B)) //* not representing K2Exp and Exp2K...
*/

endmodule
