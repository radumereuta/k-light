// parsing a configuration and printing KORE
require "kore.k"

module PREDEF
  imports KORE
  syntax Id
  syntax Bool
  syntax Int
  syntax K
  syntax KResult
  syntax Map
  syntax KBott
  syntax Layout ::= r"[\\ \n\r\t]*" [token]

  syntax Map ::= ".Map" [symbol(emptyMap)]

endmodule

module KCELLS
  imports PREDEF

  syntax Cell
  syntax Bag ::= Bag Bag  [left, assoc, symbol(consCells), unit(#cells)]
               | ".Bag"   [symbol(emptyCells)]
               | Cell [symbol(inj)]
  syntax K ::= Bag [symbol(inj)]
  syntax Bag ::= KBott [symbol(inj)]
endmodule

module CONFIG-CELLS
  imports KCELLS
  syntax CellName ::= r"[a-zA-Z][a-zA-Z0-9\\-]*"  [token, prec(1)]

  syntax Cell ::= "<" CellName">" K "</" CellName ">" [symbol(configCell)]
  syntax Cell ::= "<" CellName "/>" [symbol(externalCell)]
endmodule

module IMP-SYNTAX
  imports PREDEF
  syntax AExp  ::= Int [symbol(inj)] | Id [symbol(inj)]
                 | AExp "/" AExp              [left, strict, symbol(div)]
                 > AExp "+" AExp              [left, strict, symbol(plus)]
                 | "(" AExp ")"               [bracket, symbol(aExpBracket)]
  syntax BExp  ::= Bool [symbol(inj)]
                 | AExp "<=" AExp             [seqstrict, symbol(lte)]
                 | "!" BExp                   [strict, symbol(not)]
                 > BExp "&&" BExp             [left, strict(1), symbol(and)]
                 | "(" BExp ")"               [bracket, symbol(bExpBracket)]
  syntax Block ::= "{" "}"                    [symbol(emptyBlock)]
                 | "{" Stmt "}"               [symbol(block)]
  syntax Stmt  ::= Block [symbol(inj)]
                 | Id "=" AExp ";"            [strict(2), symbol(assignment)]
                 | "if" "(" BExp ")"
                   Block "else" Block         [strict(1), symbol(if)]
                 | "while" "(" BExp ")" Block [symbol(while)]
                 > Stmt Stmt                  [left, symbol(consStmt)]
  syntax Pgm ::= "int" Ids ";" Stmt           [symbol(program)]
  syntax Ids ::= ".Ids"      [symbol(emptyIds)]
               | Id "," Ids  [symbol(consIds)]
endmodule


module IMP-CONFIG
  imports IMP-SYNTAX
  imports CONFIG-CELLS

  syntax VarName ::= r"$[a-zA-Z][a-zA-Z0-9]*" [token]

  syntax K ::= Param [symbol(inj)]
  syntax Param ::= KBott [symbol(inj)]

  syntax K ::= Map [symbol(inj)]
  syntax Map ::= KBott [symbol(inj)]


  configuration <T>
                  <k> $PGM:Pgm </k>
                  <state> .Map </state>
                </T>


endmodule
