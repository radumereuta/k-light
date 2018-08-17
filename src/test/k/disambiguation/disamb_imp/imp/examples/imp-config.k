// parsing a configuration and printing KORE

module PREDEF
  syntax Id
  syntax Bool
  syntax Int
  syntax K
  syntax KResult
  syntax Map
  syntax KBott
  syntax KVariable
  syntax Layout ::= r"[\\ \n\r\t]*" [token]

  syntax Map ::= ".Map" [symbol(emptyMap)]
  syntax KBott ::= KVariable [symbol(inj)]
  syntax KVariable ::= r"$[A-Z][A-Za-z0-9'_]*|_" [token]

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

module IMP-SYNTAX // mostly untouched
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

module GENERATED
  imports IMP-SYNTAX
  imports CONFIG-CELLS

  // subsort diamond
  syntax K ::= Map [symbol(inj)]
  syntax Map ::= KBott [symbol(inj)]
  
  // casts
  syntax Pgm ::= Pgm ":Pgm" [symbol(castToPgm)]
    
  syntax K ::= Pgm [symbol(inj)]
  syntax Pgm ::= KBott [symbol(inj)]


endmodule

module IMP-CONFIG
  imports IMP-SYNTAX
  imports CONFIG-CELLS
  imports GENERATED

  configuration <T>
                  <k> $PGM:Pgm </k>
                  <state> .Map </state>
                </T>


endmodule
