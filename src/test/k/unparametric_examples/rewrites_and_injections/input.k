/*
 * A typical lookup rule where we rewrite from Id to Int.
 * The question is whether we need overloaded rewrites to express such
 * rules or use a generic production that takes K (the top sort).
 */
module INPUT
syntax #Layout ::= r"([\\ \n\r\t])*" [token]
syntax Exp ::= Int [klabel(Exp2Int)] | Id [klabel(Exp2Id)]
syntax K   ::= K   "=>" K   [klabel(rewK)]
syntax Exp ::= Exp "=>" Exp [klabel(rewExp)]
syntax Int ::= Int "=>" Int [klabel(rewInt)]
             | K ":Int"     [klabel(castToInt)]
syntax Id  ::= Id  "=>" Id  [klabel(rewId)]
             | K ":Id"      [klabel(castToId)]

syntax K ::= Id      [klabel(inj)]
           | Int     [klabel(inj)]
syntax Id  ::= KBott [klabel(inj)]
syntax Int ::= KBott [klabel(inj)]
syntax Variable ::= r"[A-Z][A-Za-z0-9]*" [token]
syntax KBott ::= Variable [klabel(inj)]
syntax Cell ::= "<k>" K "</k>" "<env>" K "|->" K "</env>" [klabel(cells)]

rule <k> A => B </k>        <env> A |-> B </env> [start(Cell)]
rule <k> A:Id => B:Int </k> <env> A |-> B </env> [start(Cell)]
rule <k> A => B </k>        <env> A:Id |-> B:Int </env> [start(Cell)]

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
