/*
 * This shows the importance of having lexical disambiguation tools.
 */
module INPUT

syntax Exp ::= "-" Exp [klabel(uminus)]
             | Int
syntax Int ::= r"[\\-]?[0-9]+"

// input: -1
// output: amb("-1", uminus("1"))

// input: - 1
// output: uminus("1")

endmodule

module INPUT2

syntax Exp ::= r"-(?![0-9])" Exp [klabel(uminus)]
             | Int
syntax Int ::= r"[\\-]?[0-9]+"

// input: -1
// output: "-1"
// the ambiguity is no longer present since the follow restriction eliminates the uminus production

// input: - 1
// output: uminus("1")

endmodule
