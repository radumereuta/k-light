/*
 * We want a way to specify that `callcc` is not an Id so we
 * avoid ambiguities in certain cases.
 */
module COMMON
syntax Layout ::= r"([\\ \n\r\t])*" [token2, klabel(tkLayout)]
syntax Id
syntax Exp ::= Id [klabel(inj)]
  | Exp Exp [klabel(app)]
  | "callcc" Exp [klabel(callcc)]
endmodule
 
module INPUT
import COMMON
syntax Id ::= r"[\\_a-zA-Z][\\_a-zA-Z0-9]*" [token2, reject(callcc), autoReject, klabel(tkId)]
rule callcc a [start(Exp)]
endmodule

module INPUT2
import COMMON
syntax Id ::= r"[\\_a-zA-Z][\\_a-zA-Z0-9]*" [token2, klabel(tkId2)]
rule callcc a [start(Exp)]
endmodule

// input: callcc a
// output: amb(callcc_("a"), __("callcc", "a"))
