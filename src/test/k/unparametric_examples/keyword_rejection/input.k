/*
 * We want a way to specify that `callcc` is not an Id so we
 * avoid ambiguities in certain cases.
 */

module INPUT
syntax Layout ::= r"([\\ \n\r\t])*" [token]
syntax Exp ::= Id [klabel(inj)]
  | Exp Exp [klabel(app)]
  | "callcc" Exp [klabel(callcc)]
syntax Id ::= r"[\\_a-zA-Z][\\_a-zA-Z0-9]*" [token, reject(callcc), autoReject]

rule callcc a [start(Exp)]

endmodule

module INPUT2
syntax Layout ::= r"([\\ \n\r\t])*" [token]
syntax Exp ::= Id [klabel(inj)]
  | Exp Exp [klabel(app)]
  | "callcc" Exp [klabel(callcc)]
syntax Id ::= r"[\\_a-zA-Z][\\_a-zA-Z0-9]*" [token]

rule callcc a [start(Exp)]

endmodule

// input: callcc a
// output: amb(callcc_("a"), __("callcc", "a"))
