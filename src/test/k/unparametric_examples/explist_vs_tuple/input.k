/*
 * Automatic type inference for meta-variables has to be global.
 * In the RHS of the rule there is an ambiguity between (Id, Stmt) and (Exp, Exps)
 * and the correct way to disambiguate would be to infer X:Id and S:Stmt (constraint solving)
 */
module INPUT

syntax Layout ::= r"([\\ \n\r\t])*" [token]
syntax Id
syntax Exp ::= Id                    [klabel(inj)]
syntax Exps  ::= Exp "," Exps        [klabel(expList)]
syntax Exps  ::= Exp                 [klabel(inj)]
syntax Stmt  ::= "val" Exps ";" Stmt [klabel(decl)]
syntax KBott ::= "(" K ")"           [klabel(bracket)]
syntax KBott ::= "(" Id "," Stmt ")" [klabel(tuple)]
// auto-generated or predefined
syntax K ::= K "=> " K           [klabel(rew)]
syntax K ::= Id [klabel(inj)]
 | Exp  [klabel(inj)]
 | Exps [klabel(inj)]
 | Stmt [klabel(inj)]
syntax Id ::= KBott [klabel(inj)]
syntax Exp ::= KBott [klabel(inj)]
syntax Exps ::= KBott [klabel(inj)]
syntax Stmt ::= KBott [klabel(inj)]
syntax Variable ::= r"[A-Z][A-Za-z0-9]*" [token]
syntax KBott ::= Variable [klabel(inj)]

rule val X; S => (X,S) [start(K)]

endmodule
