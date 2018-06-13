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
  syntax S10
  syntax S11
  syntax S12
  syntax S13
  syntax S14
  syntax S15
  syntax S16
  syntax S17
  syntax S18
  syntax S19
  syntax S20
  syntax S21
  syntax S22
  syntax S23
  syntax S24
  syntax S25
  syntax S26
  syntax S27
  syntax S28
  syntax S29
  syntax S30
  syntax S31
  syntax S32
  syntax S33
  syntax S34
  syntax S35
  syntax S36
  syntax S37
  syntax S38
  syntax S39
  syntax S40
  syntax S41
  syntax S42
  syntax S43
  syntax S44
  syntax S45
  syntax S46
  syntax S47
  syntax S48
  syntax S49
  syntax S50
  syntax S51
  syntax S52
  syntax S53
  syntax S54
  syntax S55
  syntax S56
  syntax S57
  syntax S58
  syntax S59
  syntax S60
  syntax S61
  syntax S62
  syntax S63
  syntax S64
  syntax S65
  syntax S66
  syntax S67
  syntax S68
  syntax S69
  syntax S70
  syntax S71
  syntax S72
  syntax S73
  syntax S74
  syntax S75
  syntax S76
  syntax S77
  syntax S78
  syntax S79
  syntax S80
  syntax S81
  syntax S82
  syntax S83
  syntax S84
  syntax S85
  syntax S86
  syntax S87
  syntax S88
  syntax S89
  syntax S90
  syntax S91
  syntax S92
  syntax S93
  syntax S94
  syntax S95
  syntax S96
  syntax S97
  syntax S98
  syntax S99
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
  syntax K  ::= S10 [symbol(inj)]
  syntax S10 ::= KBott [symbol(inj)]
  syntax K  ::= S11 [symbol(inj)]
  syntax S11 ::= KBott [symbol(inj)]
  syntax K  ::= S12 [symbol(inj)]
  syntax S12 ::= KBott [symbol(inj)]
  syntax K  ::= S13 [symbol(inj)]
  syntax S13 ::= KBott [symbol(inj)]
  syntax K  ::= S14 [symbol(inj)]
  syntax S14 ::= KBott [symbol(inj)]
  syntax K  ::= S15 [symbol(inj)]
  syntax S15 ::= KBott [symbol(inj)]
  syntax K  ::= S16 [symbol(inj)]
  syntax S16 ::= KBott [symbol(inj)]
  syntax K  ::= S17 [symbol(inj)]
  syntax S17 ::= KBott [symbol(inj)]
  syntax K  ::= S18 [symbol(inj)]
  syntax S18 ::= KBott [symbol(inj)]
  syntax K  ::= S19 [symbol(inj)]
  syntax S19 ::= KBott [symbol(inj)]
  syntax K  ::= S20 [symbol(inj)]
  syntax S20 ::= KBott [symbol(inj)]
  syntax K  ::= S21 [symbol(inj)]
  syntax S21 ::= KBott [symbol(inj)]
  syntax K  ::= S22 [symbol(inj)]
  syntax S22 ::= KBott [symbol(inj)]
  syntax K  ::= S23 [symbol(inj)]
  syntax S23 ::= KBott [symbol(inj)]
  syntax K  ::= S24 [symbol(inj)]
  syntax S24 ::= KBott [symbol(inj)]
  syntax K  ::= S25 [symbol(inj)]
  syntax S25 ::= KBott [symbol(inj)]
  syntax K  ::= S26 [symbol(inj)]
  syntax S26 ::= KBott [symbol(inj)]
  syntax K  ::= S27 [symbol(inj)]
  syntax S27 ::= KBott [symbol(inj)]
  syntax K  ::= S28 [symbol(inj)]
  syntax S28 ::= KBott [symbol(inj)]
  syntax K  ::= S29 [symbol(inj)]
  syntax S29 ::= KBott [symbol(inj)]
  syntax K  ::= S30 [symbol(inj)]
  syntax S30 ::= KBott [symbol(inj)]
  syntax K  ::= S31 [symbol(inj)]
  syntax S31 ::= KBott [symbol(inj)]
  syntax K  ::= S32 [symbol(inj)]
  syntax S32 ::= KBott [symbol(inj)]
  syntax K  ::= S33 [symbol(inj)]
  syntax S33 ::= KBott [symbol(inj)]
  syntax K  ::= S34 [symbol(inj)]
  syntax S34 ::= KBott [symbol(inj)]
  syntax K  ::= S35 [symbol(inj)]
  syntax S35 ::= KBott [symbol(inj)]
  syntax K  ::= S36 [symbol(inj)]
  syntax S36 ::= KBott [symbol(inj)]
  syntax K  ::= S37 [symbol(inj)]
  syntax S37 ::= KBott [symbol(inj)]
  syntax K  ::= S38 [symbol(inj)]
  syntax S38 ::= KBott [symbol(inj)]
  syntax K  ::= S39 [symbol(inj)]
  syntax S39 ::= KBott [symbol(inj)]
  syntax K  ::= S40 [symbol(inj)]
  syntax S40 ::= KBott [symbol(inj)]
  syntax K  ::= S41 [symbol(inj)]
  syntax S41 ::= KBott [symbol(inj)]
  syntax K  ::= S42 [symbol(inj)]
  syntax S42 ::= KBott [symbol(inj)]
  syntax K  ::= S43 [symbol(inj)]
  syntax S43 ::= KBott [symbol(inj)]
  syntax K  ::= S44 [symbol(inj)]
  syntax S44 ::= KBott [symbol(inj)]
  syntax K  ::= S45 [symbol(inj)]
  syntax S45 ::= KBott [symbol(inj)]
  syntax K  ::= S46 [symbol(inj)]
  syntax S46 ::= KBott [symbol(inj)]
  syntax K  ::= S47 [symbol(inj)]
  syntax S47 ::= KBott [symbol(inj)]
  syntax K  ::= S48 [symbol(inj)]
  syntax S48 ::= KBott [symbol(inj)]
  syntax K  ::= S49 [symbol(inj)]
  syntax S49 ::= KBott [symbol(inj)]
  syntax K  ::= S50 [symbol(inj)]
  syntax S50 ::= KBott [symbol(inj)]
  syntax K  ::= S51 [symbol(inj)]
  syntax S51 ::= KBott [symbol(inj)]
  syntax K  ::= S52 [symbol(inj)]
  syntax S52 ::= KBott [symbol(inj)]
  syntax K  ::= S53 [symbol(inj)]
  syntax S53 ::= KBott [symbol(inj)]
  syntax K  ::= S54 [symbol(inj)]
  syntax S54 ::= KBott [symbol(inj)]
  syntax K  ::= S55 [symbol(inj)]
  syntax S55 ::= KBott [symbol(inj)]
  syntax K  ::= S56 [symbol(inj)]
  syntax S56 ::= KBott [symbol(inj)]
  syntax K  ::= S57 [symbol(inj)]
  syntax S57 ::= KBott [symbol(inj)]
  syntax K  ::= S58 [symbol(inj)]
  syntax S58 ::= KBott [symbol(inj)]
  syntax K  ::= S59 [symbol(inj)]
  syntax S59 ::= KBott [symbol(inj)]
  syntax K  ::= S60 [symbol(inj)]
  syntax S60 ::= KBott [symbol(inj)]
  syntax K  ::= S61 [symbol(inj)]
  syntax S61 ::= KBott [symbol(inj)]
  syntax K  ::= S62 [symbol(inj)]
  syntax S62 ::= KBott [symbol(inj)]
  syntax K  ::= S63 [symbol(inj)]
  syntax S63 ::= KBott [symbol(inj)]
  syntax K  ::= S64 [symbol(inj)]
  syntax S64 ::= KBott [symbol(inj)]
  syntax K  ::= S65 [symbol(inj)]
  syntax S65 ::= KBott [symbol(inj)]
  syntax K  ::= S66 [symbol(inj)]
  syntax S66 ::= KBott [symbol(inj)]
  syntax K  ::= S67 [symbol(inj)]
  syntax S67 ::= KBott [symbol(inj)]
  syntax K  ::= S68 [symbol(inj)]
  syntax S68 ::= KBott [symbol(inj)]
  syntax K  ::= S69 [symbol(inj)]
  syntax S69 ::= KBott [symbol(inj)]
  syntax K  ::= S70 [symbol(inj)]
  syntax S70 ::= KBott [symbol(inj)]
  syntax K  ::= S71 [symbol(inj)]
  syntax S71 ::= KBott [symbol(inj)]
  syntax K  ::= S72 [symbol(inj)]
  syntax S72 ::= KBott [symbol(inj)]
  syntax K  ::= S73 [symbol(inj)]
  syntax S73 ::= KBott [symbol(inj)]
  syntax K  ::= S74 [symbol(inj)]
  syntax S74 ::= KBott [symbol(inj)]
  syntax K  ::= S75 [symbol(inj)]
  syntax S75 ::= KBott [symbol(inj)]
  syntax K  ::= S76 [symbol(inj)]
  syntax S76 ::= KBott [symbol(inj)]
  syntax K  ::= S77 [symbol(inj)]
  syntax S77 ::= KBott [symbol(inj)]
  syntax K  ::= S78 [symbol(inj)]
  syntax S78 ::= KBott [symbol(inj)]
  syntax K  ::= S79 [symbol(inj)]
  syntax S79 ::= KBott [symbol(inj)]
  syntax K  ::= S80 [symbol(inj)]
  syntax S80 ::= KBott [symbol(inj)]
  syntax K  ::= S81 [symbol(inj)]
  syntax S81 ::= KBott [symbol(inj)]
  syntax K  ::= S82 [symbol(inj)]
  syntax S82 ::= KBott [symbol(inj)]
  syntax K  ::= S83 [symbol(inj)]
  syntax S83 ::= KBott [symbol(inj)]
  syntax K  ::= S84 [symbol(inj)]
  syntax S84 ::= KBott [symbol(inj)]
  syntax K  ::= S85 [symbol(inj)]
  syntax S85 ::= KBott [symbol(inj)]
  syntax K  ::= S86 [symbol(inj)]
  syntax S86 ::= KBott [symbol(inj)]
  syntax K  ::= S87 [symbol(inj)]
  syntax S87 ::= KBott [symbol(inj)]
  syntax K  ::= S88 [symbol(inj)]
  syntax S88 ::= KBott [symbol(inj)]
  syntax K  ::= S89 [symbol(inj)]
  syntax S89 ::= KBott [symbol(inj)]
  syntax K  ::= S90 [symbol(inj)]
  syntax S90 ::= KBott [symbol(inj)]
  syntax K  ::= S91 [symbol(inj)]
  syntax S91 ::= KBott [symbol(inj)]
  syntax K  ::= S92 [symbol(inj)]
  syntax S92 ::= KBott [symbol(inj)]
  syntax K  ::= S93 [symbol(inj)]
  syntax S93 ::= KBott [symbol(inj)]
  syntax K  ::= S94 [symbol(inj)]
  syntax S94 ::= KBott [symbol(inj)]
  syntax K  ::= S95 [symbol(inj)]
  syntax S95 ::= KBott [symbol(inj)]
  syntax K  ::= S96 [symbol(inj)]
  syntax S96 ::= KBott [symbol(inj)]
  syntax K  ::= S97 [symbol(inj)]
  syntax S97 ::= KBott [symbol(inj)]
  syntax K  ::= S98 [symbol(inj)]
  syntax S98 ::= KBott [symbol(inj)]
  syntax K  ::= S99 [symbol(inj)]
  syntax S99 ::= KBott [symbol(inj)]

endmodule

module S0100
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
