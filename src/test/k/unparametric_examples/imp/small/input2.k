module INPUT2
syntax Layout ::= r"([\\ \n\r\t])*" [token]
syntax Int ::= r"[0-9]+" [token]
syntax Exp ::= Int [symbol(inj)]
             | Id  [symbol(inj)]
             | Exp "*" Exp [symbol(mul)]
             | Exp "+" Exp [symbol(plus)]

syntax KBott ::= K "=>" K   [symbol(rew)]

syntax Int ::= Int ":Int"     [symbol(castToInt)]
syntax Id  ::= Id  ":Id"      [symbol(castToId)]
syntax Exp ::= Exp ":Exp"     [symbol(castToExp)]

syntax K ::= KBott   [symbol(inj)]
           | Exp     [symbol(inj)]
           | Id      [symbol(inj)]
           | Int     [symbol(inj)]
syntax Id  ::= KBott [symbol(inj)]
syntax Int ::= KBott [symbol(inj)]
syntax Exp ::= KBott [symbol(inj)]

syntax Variable ::= r"[A-Z][A-Za-z0-9]*" [token]
syntax KBott ::= Variable [symbol(inj)]
syntax Cell ::= "<a>" K "</a>" [symbol(kcell)]

rule <a> C </a>                                  [start(Cell)]
rule <a> D:Int </a>                              [start(Cell)]
rule <a> A:Int => B:Int </a>                     [start(Cell)]
rule <a> 1 + 2 * 3 </a>                          [start(Cell)]

endmodule
