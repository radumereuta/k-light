/*
 * Automatic type inference for meta-variables has to be global.
 * In the RHS of the rule there is an ambiguity between (Id, Stmt) and (Exp, Exps)
 * and the correct way to disambiguate would be to infer X:Id and S:Stmt (constraint solving)
 */
module INPUT

syntax Layout ::= r"([\\ \n\r\t])*" [token]
syntax Id
syntax Exp ::= Id                    [symbol(inj)]
syntax Exps  ::= Exp "," Exps        [symbol(expList)]
syntax Exps  ::= Exp                 [symbol(inj)]
syntax Stmt  ::= "val" Exps ";" Stmt [symbol(decl)]
syntax KBott ::= "(" K ")"           [symbol(bracket)]
syntax KBott ::= "(" Id "," Stmt ")" [symbol(tuple)]
// auto-generated or predefined
syntax K ::= K "=> " K           [symbol(rew)]
syntax K ::= Id [symbol(inj)]
 | Exp  [symbol(inj)]
 | Exps [symbol(inj)]
 | Stmt [symbol(inj)]
syntax Id ::= KBott [symbol(inj)]
syntax Exp ::= KBott [symbol(inj)]
syntax Exps ::= KBott [symbol(inj)]
syntax Stmt ::= KBott [symbol(inj)]
syntax Variable ::= r"[A-Z][A-Za-z0-9]*" [token]
syntax KBott ::= Variable [symbol(inj)]

rule val X; S => (X,S) [start(K)]

endmodule
