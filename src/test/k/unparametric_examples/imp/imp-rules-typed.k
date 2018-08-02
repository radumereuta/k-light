// parsing a configuration and printing KORE

module PREDEF
  syntax Id
  syntax Bool
  syntax Int
  syntax K
  syntax KResult
  syntax Map
  syntax KBott
  syntax Set
  syntax KVariable
  syntax Layout ::= r"[\\ \n\r\t]*" [token]

  // kapp
  syntax KBott ::= K "=>" K [symbol(kRewrite)]
  syntax KBott ::= K "~>" K [symbol(kSequence)]
  syntax KBott ::= "(" K ")" [symbol(kBracket)]
  syntax KBott ::= KVariable [symbol(inj)]
  syntax KVariable ::= r"[A-Z][A-Za-z0-9'_]*|_" [token]
  syntax K ::= KBott [symbol(inj)]
  syntax KBott ::= "." [symbol(dotK)]
  
  syntax K ::= K "requires" K [symbol(kRequires)]

  // Map  
  syntax Map ::= K "|->" K [symbol(mapElement)]
  syntax Map ::= Map Map [symbol(consMap)]
  syntax Map ::= ".Map" [symbol(emptyMap)]
  
  // Int
  syntax Int ::= Int "+Int" Int [symbol(plusInt)]
  syntax Int ::= Int "/Int" Int [symbol(divInt)]
  syntax Int ::= Int "<=Int" Int [symbol(lteInt)]
  syntax Int ::= Int "=/=Int" Int [symbol(neInt)]
  syntax Int ::= r"[0-9]+" [token]
  
  // Bool
  syntax Bool ::= "true" [symbol(boolTrue)]
  syntax Bool ::= "false" [symbol(boolFalse)]
  syntax Bool ::= Bool "&&" Bool [symbol(boolAnd)]
  syntax Bool ::= "notBool" Bool [symbol(notBool)]
  
  // Set
  syntax Bool ::= K "in_keys" "(" Map ")" [symbol(inKeys)]
  

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

module RULE-CELLS
  imports KCELLS
  syntax OptionalDots ::= "..." [symbol(dots)]
                        | ""    [symbol(noDots)]

  // should be automatically generated:
  syntax Cell ::= "<T>" OptionalDots K OptionalDots "</top>" [symbol(tCell)]
  syntax Cell ::= "<k>" OptionalDots K OptionalDots "</k>" [symbol(kCell)]
  syntax Cell ::= "<state>" OptionalDots K OptionalDots "</state>" [symbol(stateCell)]

endmodule

module IMP-SYNTAX // mostly untouched
  imports PREDEF
  syntax AExp  ::= Int [symbol(inj)] | Id [symbol(inj)]
                 | AExp "/" AExp              [left, strict, symbol(div)]
                 > AExp "+" AExp              [left, strict, symbol(plus)]
                 | "(" AExp ")"               [symbol(aExpBracket)]
  syntax BExp  ::= Bool [symbol(inj)]
                 | AExp "<=" AExp             [seqstrict, symbol(lte)]
                 | "!" BExp                   [strict, symbol(not)]
                 > BExp "&&" BExp             [left, strict(1), symbol(and)]
                 | "(" BExp ")"               [symbol(bExpBracket)]
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
  imports RULE-CELLS

  // subsort diamond
  syntax K ::= Map [symbol(inj)]
  syntax Map ::= KBott [symbol(inj)]

  // casts
  syntax Int  ::= Int  ":Int"  [symbol(cast)]
  syntax Id   ::= Id   ":Id"   [symbol(cast)]
  syntax Stmt ::= Stmt ":Stmt" [symbol(cast)]
  syntax Map  ::= Map  ":Map"  [symbol(cast)]
  syntax Stmt ::= Stmt ":Stmt" [symbol(cast)]
  syntax Block::= Block":Block"[symbol(cast)]
  syntax BExp ::= BExp ":BExp" [symbol(cast)]
  syntax Bool ::= Bool ":Bool" [symbol(cast)]
  syntax Ids  ::= Ids  ":Ids"  [symbol(cast)]
  syntax K    ::= K    ":K"    [symbol(cast)]

  syntax K ::= Pgm [symbol(inj)]
  syntax Pgm ::= KBott [symbol(inj)]

  syntax Id ::= KBott [symbol(inj)]
  syntax K ::= Id [symbol(inj)]
  
  syntax Int ::= KBott [symbol(inj)]
  syntax K ::= Int [symbol(inj)]

  syntax Bool ::= KBott [symbol(inj)]
  syntax K ::= Bool [symbol(inj)]
  
  syntax Stmt ::= KBott [symbol(inj)]
  syntax K ::= Stmt [symbol(inj)]
  
  syntax Stmt ::= KBott [symbol(inj)]
  syntax K ::= Stmt  [symbol(inj)]
  
  syntax AExp ::= KBott [symbol(inj)]
  syntax K ::= AExp [symbol(inj)]

  syntax BExp ::= KBott [symbol(inj)]
  syntax K ::= BExp [symbol(inj)]
  
  syntax Block ::= KBott [symbol(inj)]
  syntax K ::= Block [symbol(inj)]

  syntax Ids ::= KBott [symbol(inj)]
  syntax K ::= Ids [symbol(inj)]

endmodule

module IMP-RULES-TYPED
  imports IMP-SYNTAX
  imports RULE-CELLS
  imports GENERATED

// AExp
  rule <k> X:Id => I:Int ...</k> <state>... X:Id |-> I:Int ...</state>
  rule I1:Int / I2:Int => I1:Int /Int I2:Int  requires I2:Int =/=Int 0
  rule I1:Int + I2:Int => I1:Int +Int I2:Int
// BExp
  rule I1:Int <= I2:Int => I1:Int <=Int I2:Int
  rule ! T:Bool => notBool T:Bool
  rule true && B:BExp => B:BExp
  rule false && _:BExp => false
// Block
  rule {} => .   [structural]
  rule {S:Stmt} => S:Stmt  [structural]
// Stmt
  rule <k> X:Id = I:Int; => . ...</k> <state>... X:Id |-> (_:K => I:Int) ...</state>
  rule S1:Stmt S2:Stmt => S1:Stmt ~> S2:Stmt  [structural]
  rule if (true)  S:Block else _:Block => S:Block
  rule if (false) _:Block else S:Block => S:Block
  rule while (B:BExp) S:Block => if (B:BExp) {S:Block while (B:BExp) S:Block} else {}  [structural]
// Pgm
  rule <k> int (X:Id,Xs:Ids => Xs:Ids);_:Stmt </k> <state> Rho:Map (.Map => X:Id|->0) </state>
    requires notBool (X:Id in_keys(Rho:Map))
  rule int .Ids; S:Stmt => S:Stmt  [structural]

endmodule
