module SMALL
syntax Layout ::= r"([\\ \n\r\t])*" [token]
syntax Int ::= r"[0-9]+" [token]
syntax Exp ::= Int [symbol(inj)]
             | Id  [symbol(inj)]
             | Exp "[" Exp "]" [symbol(array)]
             | Exp "*" Exp [symbol(mul)]
             | Exp "+" Exp [symbol(plus)]

//syntax{S}  S ::= S "=>" S     [symbol(rew)]
//syntax KBott ::= K "=>" K     [symbol(rew)] // maybe should look like this eventually
//syntax K   ::= K   "=>" K     [symbol(rew)]
syntax Exp ::= Exp "=>" Exp   [symbol(rew)]
syntax Int ::= Int "=>" Int   [symbol(rew)]
syntax Id  ::= Id  "=>" Id    [symbol(rew)]
//syntax KBott ::= KBott "=>" KBott   [symbol(rew)]

syntax Int ::= Int ":Int"     [symbol(cast)]
syntax Id  ::= Id  ":Id"      [symbol(cast)]
syntax Exp ::= Exp ":Exp"     [symbol(cast)]

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
rule <a> 1 + 2 * 3 + 4 </a>                      [start(Cell)]
rule <a> 1 * 2 + 3 * 4 </a>                      [start(Cell)]
rule <a> 1 + 2 [ 3 + 4 * 5 ] </a>                [start(Cell)]
rule <a> 2:Exp </a>                              [start(Cell)]
rule <a> 1 + 2 => 3 </a>                         [start(Cell)]

endmodule
