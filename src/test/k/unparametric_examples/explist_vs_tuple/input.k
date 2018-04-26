/*
 * Automatic type inference for meta-variables has to be global.
 * In the RHS of the rule there is an ambiguity between (Id, Stmt) and (Exp, Exps)
 * and the correct way to disambiguate would be to infer X:Id and S:Stmt (constraint solving)
 */
module INPUT

syntax Id
syntax Exp ::= Id
syntax Exps  ::= Exp "," Exps | Exp
syntax Stmt  ::= "val" Exps ";" Stmt
syntax KBott ::= "(" K ")" | "(" Id "," Stmt ")"
// auto-generated or predefined
syntax KBott ::= K "=> " K
syntax K ::= Id | Exp | Exps | Stmt
syntax Id ::= KBott
syntax Exp ::= KBott
syntax Exps ::= KBott
syntax Stmt ::= KBott
syntax Variable ::= r"[A-Z][A-Za-z0-9]*"
syntax KBott ::= Variable

rule val X; S => (X,S)

endmodule
