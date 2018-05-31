// Copyright (c) 2014-2016 K Team. All Rights Reserved.

module PREDEF
  syntax Id
  syntax Bool
  syntax Int
  syntax K
  syntax KResult
  syntax Map

endmodule

module IMP-SYNTAX
  imports PREDEF
  syntax AExp  ::= Int | Id
                 | AExp "/" AExp              [left, strict, symbol(div)]
                 > AExp "+" AExp              [left, strict, symbol(plus)]
                 | "(" AExp ")"               [bracket, symbol(aExpBracket)]
  syntax BExp  ::= Bool
                 | AExp "<=" AExp             [seqstrict, symbol(lte)]
                 | "!" BExp                   [strict, symbol(not)]
                 > BExp "&&" BExp             [left, strict(1), symbol(and)]
                 | "(" BExp ")"               [bracket, symbol(bExpBracket)]
  syntax Block ::= "{" "}"                    [symbol(emptyBlock)]
                 | "{" Stmt "}"               [symbol(block)]
  syntax Stmt  ::= Block
                 | Id "=" AExp ";"            [strict(2), symbol(assignment)]
                 | "if" "(" BExp ")"
                   Block "else" Block         [strict(1), symbol(if)]
                 | "while" "(" BExp ")" Block [symbol(while)]
                 > Stmt Stmt                  [left, symbol(consStmt)]
  syntax Pgm ::= "int" Ids ";" Stmt           [symbol(program)]
  syntax Ids ::= ".Ids"      [symbol(emptyIds)]
               | Id "," Ids  [symbol(consIds)]
endmodule


module IMP
  imports IMP-SYNTAX
  syntax KResult ::= Int | Bool

  configuration <T color="yellow">
                  <k color="green"> $PGM:Pgm </k>
                  <state color="red"> .Map </state>
                </T>

// AExp
  rule <k> X:Id => I ...</k> <state>... X |-> I ...</state>
  rule I1 / I2 => I1 /Int I2  requires I2 =/=Int 0
  rule I1 + I2 => I1 +Int I2
// BExp
  rule I1 <= I2 => I1 <=Int I2
  rule ! T => notBool T
  rule true && B => B
  rule false && _ => false
// Block
  rule {} => .   [structural]
  rule {S} => S  [structural]
// Stmt
  rule <k> X = I:Int; => . ...</k> <state>... X |-> (_ => I) ...</state>
  rule S1:Stmt S2:Stmt => S1 ~> S2  [structural]
  rule if (true)  S else _ => S
  rule if (false) _ else S => S
  rule while (B) S => if (B) {S while (B) S} else {}  [structural]
// Pgm
  rule <k> int (X,Xs => Xs);_ </k> <state> Rho:Map (.Map => X|->0) </state>
    requires notBool (X in keys(Rho))
  rule int .Ids; S => S  [structural]

// verification ids
  syntax Id ::= "n"     [token]
              | "sum"   [token]
endmodule
