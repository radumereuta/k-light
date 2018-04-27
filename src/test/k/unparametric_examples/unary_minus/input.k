/*
 * This shows the importance of having lexical disambiguation tools.
 */
module INPUT
syntax #Layout ::= r"([\\ \n\r\t])*" [token]

syntax Exp ::= "-" Exp [klabel(uminus)]
             | Int     [klabel(inj)]
syntax Int ::= r"[\\-]?[0-9]+" [token]

rule -1 [start(Exp)]
// output: amb("-1", uminus("1"))

rule - 1 [start(Exp)]
// output: uminus("1")

endmodule

module INPUT2
syntax #Layout ::= r"([\\ \n\r\t])*" [token]

syntax Exp ::= r"-(?![0-9])" Exp [klabel(uminus)]
             | Int               [klabel(inj)]
syntax Int ::= r"[\\-]?[0-9]+"   [token]

rule -1 [start(Exp)]
// output: "-1"
// the ambiguity is no longer present since the follow restriction eliminates the uminus production

rule - 1 [start(Exp)]
// output: uminus("1")

endmodule
