/*
 * We want a way to specify that `callcc` is not an Id so we
 * avoid ambiguities in certain cases.
 */
module COMMON
syntax Layout ::= r"([\\ \n\r\t])*" [token]
syntax Id
syntax Exp ::= Id [symbol(inj)]
  | Exp Exp [symbol(app)]
  | "callcc" Exp [symbol(callcc)]
endmodule
 
module INPUT
import COMMON
syntax Id ::= r"[\\_a-zA-Z][\\_a-zA-Z0-9]*" [token, reject(callcc), autoReject]
rule callcc a [start(Exp)]
endmodule

module INPUT2
import COMMON
syntax Id ::= r"[\\_a-zA-Z][\\_a-zA-Z0-9]*" [token]
rule callcc a [start(Exp)]
endmodule

// input: callcc a
// output: amb(callcc_("a"), __("callcc", "a"))
