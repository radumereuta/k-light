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

endmodule

module S0000
  imports PREDEF
  imports CASTS

  syntax S
  syntax S ::= "{" S  "}:S" [symbol(semanticCastToS)]
  syntax S ::= "{" S "}::S" [symbol(syntacticCastToS)]
  syntax S ::= "{" K "}:>S" [symbol(outerCastToS)]
  syntax KBott ::= "{" S "}<:S" [symbol(innerCastToS)]

  rule {A}:S => {B}:S
  rule {A}:S => {B}:S
  rule {A}:S => {B}:S
  rule {A}:S => {B}:S
  rule {A}:S => {B}:S
  rule {A}:S => {B}:S
  rule {A}:S => {B}:S
  rule {A}:S => {B}:S
  rule {A}:S => {B}:S
  rule {A}:S => {B}:S
endmodule
