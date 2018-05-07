/*
 * This shows the importance of having lexical disambiguation tools.
 */
module COMMON
syntax Layout ::= r"([\\ \n\r\t])*" [token2, klabel(tkLayout)]
syntax Exp ::= Int     [klabel(inj)]
syntax Int ::= r"[\\-]?[0-9]+" [token2, klabel(tkInt)]
endmodule 

module INPUT
import COMMON
syntax Exp ::= "-" Exp [klabel(uminuss)]

rule -1 [start(Exp)]
// output: amb("-1", uminus("1"))

rule - 1 [start(Exp)]
// output: uminus("1")
endmodule

module INPUT2
import COMMON
syntax Exp ::= r"-(?![0-9])" Exp [klabel(uminusp)]

rule -1 [start(Exp)]
// output: "-1"
// the ambiguity is no longer present since the follow restriction eliminates the uminus production

rule - 1 [start(Exp)]
// output: uminus("1")
endmodule
