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

module CASTS
imports PREDEF
  syntax S0
  syntax S1
  syntax S2
  syntax S3
  syntax S4
  syntax S5
  syntax S6
  syntax S7
  syntax S8
  syntax S9
  syntax K  ::= S0 [symbol(inj)]
  syntax S0 ::= KBott [symbol(inj)]
  syntax K  ::= S1 [symbol(inj)]
  syntax S1 ::= KBott [symbol(inj)]
  syntax K  ::= S2 [symbol(inj)]
  syntax S2 ::= KBott [symbol(inj)]
  syntax K  ::= S3 [symbol(inj)]
  syntax S3 ::= KBott [symbol(inj)]
  syntax K  ::= S4 [symbol(inj)]
  syntax S4 ::= KBott [symbol(inj)]
  syntax K  ::= S5 [symbol(inj)]
  syntax S5 ::= KBott [symbol(inj)]
  syntax K  ::= S6 [symbol(inj)]
  syntax S6 ::= KBott [symbol(inj)]
  syntax K  ::= S7 [symbol(inj)]
  syntax S7 ::= KBott [symbol(inj)]
  syntax K  ::= S8 [symbol(inj)]
  syntax S8 ::= KBott [symbol(inj)]
  syntax K  ::= S9 [symbol(inj)]
  syntax S9 ::= KBott [symbol(inj)]

  syntax S0 ::= "{" S0  "}:S0" [symbol(semanticCastToS0)]
  syntax S0 ::= "{" S0 "}::S0" [symbol(syntacticCastToS0)]
  syntax S0 ::= "{" K "}:>S0" [symbol(outerCastToS0)]
  syntax KBott ::= "{" S0 "}<:S0" [symbol(innerCastToS0)]
  syntax S1 ::= "{" S1  "}:S1" [symbol(semanticCastToS1)]
  syntax S1 ::= "{" S1 "}::S1" [symbol(syntacticCastToS1)]
  syntax S1 ::= "{" K "}:>S1" [symbol(outerCastToS1)]
  syntax KBott ::= "{" S1 "}<:S1" [symbol(innerCastToS1)]
  syntax S2 ::= "{" S2  "}:S2" [symbol(semanticCastToS2)]
  syntax S2 ::= "{" S2 "}::S2" [symbol(syntacticCastToS2)]
  syntax S2 ::= "{" K "}:>S2" [symbol(outerCastToS2)]
  syntax KBott ::= "{" S2 "}<:S2" [symbol(innerCastToS2)]
  syntax S3 ::= "{" S3  "}:S3" [symbol(semanticCastToS3)]
  syntax S3 ::= "{" S3 "}::S3" [symbol(syntacticCastToS3)]
  syntax S3 ::= "{" K "}:>S3" [symbol(outerCastToS3)]
  syntax KBott ::= "{" S3 "}<:S3" [symbol(innerCastToS3)]
  syntax S4 ::= "{" S4  "}:S4" [symbol(semanticCastToS4)]
  syntax S4 ::= "{" S4 "}::S4" [symbol(syntacticCastToS4)]
  syntax S4 ::= "{" K "}:>S4" [symbol(outerCastToS4)]
  syntax KBott ::= "{" S4 "}<:S4" [symbol(innerCastToS4)]
  syntax S5 ::= "{" S5  "}:S5" [symbol(semanticCastToS5)]
  syntax S5 ::= "{" S5 "}::S5" [symbol(syntacticCastToS5)]
  syntax S5 ::= "{" K "}:>S5" [symbol(outerCastToS5)]
  syntax KBott ::= "{" S5 "}<:S5" [symbol(innerCastToS5)]
  syntax S6 ::= "{" S6  "}:S6" [symbol(semanticCastToS6)]
  syntax S6 ::= "{" S6 "}::S6" [symbol(syntacticCastToS6)]
  syntax S6 ::= "{" K "}:>S6" [symbol(outerCastToS6)]
  syntax KBott ::= "{" S6 "}<:S6" [symbol(innerCastToS6)]
  syntax S7 ::= "{" S7  "}:S7" [symbol(semanticCastToS7)]
  syntax S7 ::= "{" S7 "}::S7" [symbol(syntacticCastToS7)]
  syntax S7 ::= "{" K "}:>S7" [symbol(outerCastToS7)]
  syntax KBott ::= "{" S7 "}<:S7" [symbol(innerCastToS7)]
  syntax S8 ::= "{" S8  "}:S8" [symbol(semanticCastToS8)]
  syntax S8 ::= "{" S8 "}::S8" [symbol(syntacticCastToS8)]
  syntax S8 ::= "{" K "}:>S8" [symbol(outerCastToS8)]
  syntax KBott ::= "{" S8 "}<:S8" [symbol(innerCastToS8)]
  syntax S9 ::= "{" S9  "}:S9" [symbol(semanticCastToS9)]
  syntax S9 ::= "{" S9 "}::S9" [symbol(syntacticCastToS9)]
  syntax S9 ::= "{" K "}:>S9" [symbol(outerCastToS9)]
  syntax KBott ::= "{" S9 "}<:S9" [symbol(innerCastToS9)]

endmodule

module S0010
  imports PREDEF
  imports CASTS

  rule A => B
  rule A => B
  rule A => B
  rule A => B
  rule A => B
  rule A => B
  rule A => B
  rule A => B
  rule A => B
  rule A => B

endmodule
