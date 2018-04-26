/*
 * We want a way to specify that `callcc` is not an Id so we
 * avoid ambiguities in certain cases.
 */

module INPUT

syntax Exp ::= Id
  | Exp Exp
  | "callcc" Exp
syntax Id ::= r"[\\_a-zA-Z][\\_a-zA-Z0-9]*" [reject(callcc), autoReject]

endmodule

// input: callcc a
// output: amb(callcc_("a"), __("callcc", "a"))
