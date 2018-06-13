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

  syntax S0 ::= "S0:(" S0 ")" [symbol(semanticCastToS0)]
  syntax S0 ::= "S0::(" S0 ")" [symbol(syntacticCastToS0)]
  syntax S0 ::= "S0<:(" K ")" [symbol(outerCastToS0)]
  syntax KBott ::= "S0:>(" S0 ")" [symbol(innerCastToS0)]
  syntax S1 ::= "S1:(" S1 ")" [symbol(semanticCastToS1)]
  syntax S1 ::= "S1::(" S1 ")" [symbol(syntacticCastToS1)]
  syntax S1 ::= "S1<:(" K ")" [symbol(outerCastToS1)]
  syntax KBott ::= "S1:>(" S1 ")" [symbol(innerCastToS1)]
  syntax S2 ::= "S2:(" S2 ")" [symbol(semanticCastToS2)]
  syntax S2 ::= "S2::(" S2 ")" [symbol(syntacticCastToS2)]
  syntax S2 ::= "S2<:(" K ")" [symbol(outerCastToS2)]
  syntax KBott ::= "S2:>(" S2 ")" [symbol(innerCastToS2)]
  syntax S3 ::= "S3:(" S3 ")" [symbol(semanticCastToS3)]
  syntax S3 ::= "S3::(" S3 ")" [symbol(syntacticCastToS3)]
  syntax S3 ::= "S3<:(" K ")" [symbol(outerCastToS3)]
  syntax KBott ::= "S3:>(" S3 ")" [symbol(innerCastToS3)]
  syntax S4 ::= "S4:(" S4 ")" [symbol(semanticCastToS4)]
  syntax S4 ::= "S4::(" S4 ")" [symbol(syntacticCastToS4)]
  syntax S4 ::= "S4<:(" K ")" [symbol(outerCastToS4)]
  syntax KBott ::= "S4:>(" S4 ")" [symbol(innerCastToS4)]
  syntax S5 ::= "S5:(" S5 ")" [symbol(semanticCastToS5)]
  syntax S5 ::= "S5::(" S5 ")" [symbol(syntacticCastToS5)]
  syntax S5 ::= "S5<:(" K ")" [symbol(outerCastToS5)]
  syntax KBott ::= "S5:>(" S5 ")" [symbol(innerCastToS5)]
  syntax S6 ::= "S6:(" S6 ")" [symbol(semanticCastToS6)]
  syntax S6 ::= "S6::(" S6 ")" [symbol(syntacticCastToS6)]
  syntax S6 ::= "S6<:(" K ")" [symbol(outerCastToS6)]
  syntax KBott ::= "S6:>(" S6 ")" [symbol(innerCastToS6)]
  syntax S7 ::= "S7:(" S7 ")" [symbol(semanticCastToS7)]
  syntax S7 ::= "S7::(" S7 ")" [symbol(syntacticCastToS7)]
  syntax S7 ::= "S7<:(" K ")" [symbol(outerCastToS7)]
  syntax KBott ::= "S7:>(" S7 ")" [symbol(innerCastToS7)]
  syntax S8 ::= "S8:(" S8 ")" [symbol(semanticCastToS8)]
  syntax S8 ::= "S8::(" S8 ")" [symbol(syntacticCastToS8)]
  syntax S8 ::= "S8<:(" K ")" [symbol(outerCastToS8)]
  syntax KBott ::= "S8:>(" S8 ")" [symbol(innerCastToS8)]
  syntax S9 ::= "S9:(" S9 ")" [symbol(semanticCastToS9)]
  syntax S9 ::= "S9::(" S9 ")" [symbol(syntacticCastToS9)]
  syntax S9 ::= "S9<:(" K ")" [symbol(outerCastToS9)]
  syntax KBott ::= "S9:>(" S9 ")" [symbol(innerCastToS9)]
  syntax S10 ::= "S10:(" S10 ")" [symbol(semanticCastToS10)]
  syntax S10 ::= "S10::(" S10 ")" [symbol(syntacticCastToS10)]
  syntax S10 ::= "S10<:(" K ")" [symbol(outerCastToS10)]
  syntax KBott ::= "S10:>(" S10 ")" [symbol(innerCastToS10)]
  syntax S11 ::= "S11:(" S11 ")" [symbol(semanticCastToS11)]
  syntax S11 ::= "S11::(" S11 ")" [symbol(syntacticCastToS11)]
  syntax S11 ::= "S11<:(" K ")" [symbol(outerCastToS11)]
  syntax KBott ::= "S11:>(" S11 ")" [symbol(innerCastToS11)]
  syntax S12 ::= "S12:(" S12 ")" [symbol(semanticCastToS12)]
  syntax S12 ::= "S12::(" S12 ")" [symbol(syntacticCastToS12)]
  syntax S12 ::= "S12<:(" K ")" [symbol(outerCastToS12)]
  syntax KBott ::= "S12:>(" S12 ")" [symbol(innerCastToS12)]
  syntax S13 ::= "S13:(" S13 ")" [symbol(semanticCastToS13)]
  syntax S13 ::= "S13::(" S13 ")" [symbol(syntacticCastToS13)]
  syntax S13 ::= "S13<:(" K ")" [symbol(outerCastToS13)]
  syntax KBott ::= "S13:>(" S13 ")" [symbol(innerCastToS13)]
  syntax S14 ::= "S14:(" S14 ")" [symbol(semanticCastToS14)]
  syntax S14 ::= "S14::(" S14 ")" [symbol(syntacticCastToS14)]
  syntax S14 ::= "S14<:(" K ")" [symbol(outerCastToS14)]
  syntax KBott ::= "S14:>(" S14 ")" [symbol(innerCastToS14)]
  syntax S15 ::= "S15:(" S15 ")" [symbol(semanticCastToS15)]
  syntax S15 ::= "S15::(" S15 ")" [symbol(syntacticCastToS15)]
  syntax S15 ::= "S15<:(" K ")" [symbol(outerCastToS15)]
  syntax KBott ::= "S15:>(" S15 ")" [symbol(innerCastToS15)]
  syntax S16 ::= "S16:(" S16 ")" [symbol(semanticCastToS16)]
  syntax S16 ::= "S16::(" S16 ")" [symbol(syntacticCastToS16)]
  syntax S16 ::= "S16<:(" K ")" [symbol(outerCastToS16)]
  syntax KBott ::= "S16:>(" S16 ")" [symbol(innerCastToS16)]
  syntax S17 ::= "S17:(" S17 ")" [symbol(semanticCastToS17)]
  syntax S17 ::= "S17::(" S17 ")" [symbol(syntacticCastToS17)]
  syntax S17 ::= "S17<:(" K ")" [symbol(outerCastToS17)]
  syntax KBott ::= "S17:>(" S17 ")" [symbol(innerCastToS17)]
  syntax S18 ::= "S18:(" S18 ")" [symbol(semanticCastToS18)]
  syntax S18 ::= "S18::(" S18 ")" [symbol(syntacticCastToS18)]
  syntax S18 ::= "S18<:(" K ")" [symbol(outerCastToS18)]
  syntax KBott ::= "S18:>(" S18 ")" [symbol(innerCastToS18)]
  syntax S19 ::= "S19:(" S19 ")" [symbol(semanticCastToS19)]
  syntax S19 ::= "S19::(" S19 ")" [symbol(syntacticCastToS19)]
  syntax S19 ::= "S19<:(" K ")" [symbol(outerCastToS19)]
  syntax KBott ::= "S19:>(" S19 ")" [symbol(innerCastToS19)]
  syntax S20 ::= "S20:(" S20 ")" [symbol(semanticCastToS20)]
  syntax S20 ::= "S20::(" S20 ")" [symbol(syntacticCastToS20)]
  syntax S20 ::= "S20<:(" K ")" [symbol(outerCastToS20)]
  syntax KBott ::= "S20:>(" S20 ")" [symbol(innerCastToS20)]
  syntax S21 ::= "S21:(" S21 ")" [symbol(semanticCastToS21)]
  syntax S21 ::= "S21::(" S21 ")" [symbol(syntacticCastToS21)]
  syntax S21 ::= "S21<:(" K ")" [symbol(outerCastToS21)]
  syntax KBott ::= "S21:>(" S21 ")" [symbol(innerCastToS21)]
  syntax S22 ::= "S22:(" S22 ")" [symbol(semanticCastToS22)]
  syntax S22 ::= "S22::(" S22 ")" [symbol(syntacticCastToS22)]
  syntax S22 ::= "S22<:(" K ")" [symbol(outerCastToS22)]
  syntax KBott ::= "S22:>(" S22 ")" [symbol(innerCastToS22)]
  syntax S23 ::= "S23:(" S23 ")" [symbol(semanticCastToS23)]
  syntax S23 ::= "S23::(" S23 ")" [symbol(syntacticCastToS23)]
  syntax S23 ::= "S23<:(" K ")" [symbol(outerCastToS23)]
  syntax KBott ::= "S23:>(" S23 ")" [symbol(innerCastToS23)]
  syntax S24 ::= "S24:(" S24 ")" [symbol(semanticCastToS24)]
  syntax S24 ::= "S24::(" S24 ")" [symbol(syntacticCastToS24)]
  syntax S24 ::= "S24<:(" K ")" [symbol(outerCastToS24)]
  syntax KBott ::= "S24:>(" S24 ")" [symbol(innerCastToS24)]
  syntax S25 ::= "S25:(" S25 ")" [symbol(semanticCastToS25)]
  syntax S25 ::= "S25::(" S25 ")" [symbol(syntacticCastToS25)]
  syntax S25 ::= "S25<:(" K ")" [symbol(outerCastToS25)]
  syntax KBott ::= "S25:>(" S25 ")" [symbol(innerCastToS25)]
  syntax S26 ::= "S26:(" S26 ")" [symbol(semanticCastToS26)]
  syntax S26 ::= "S26::(" S26 ")" [symbol(syntacticCastToS26)]
  syntax S26 ::= "S26<:(" K ")" [symbol(outerCastToS26)]
  syntax KBott ::= "S26:>(" S26 ")" [symbol(innerCastToS26)]
  syntax S27 ::= "S27:(" S27 ")" [symbol(semanticCastToS27)]
  syntax S27 ::= "S27::(" S27 ")" [symbol(syntacticCastToS27)]
  syntax S27 ::= "S27<:(" K ")" [symbol(outerCastToS27)]
  syntax KBott ::= "S27:>(" S27 ")" [symbol(innerCastToS27)]
  syntax S28 ::= "S28:(" S28 ")" [symbol(semanticCastToS28)]
  syntax S28 ::= "S28::(" S28 ")" [symbol(syntacticCastToS28)]
  syntax S28 ::= "S28<:(" K ")" [symbol(outerCastToS28)]
  syntax KBott ::= "S28:>(" S28 ")" [symbol(innerCastToS28)]
  syntax S29 ::= "S29:(" S29 ")" [symbol(semanticCastToS29)]
  syntax S29 ::= "S29::(" S29 ")" [symbol(syntacticCastToS29)]
  syntax S29 ::= "S29<:(" K ")" [symbol(outerCastToS29)]
  syntax KBott ::= "S29:>(" S29 ")" [symbol(innerCastToS29)]
  syntax S30 ::= "S30:(" S30 ")" [symbol(semanticCastToS30)]
  syntax S30 ::= "S30::(" S30 ")" [symbol(syntacticCastToS30)]
  syntax S30 ::= "S30<:(" K ")" [symbol(outerCastToS30)]
  syntax KBott ::= "S30:>(" S30 ")" [symbol(innerCastToS30)]
  syntax S31 ::= "S31:(" S31 ")" [symbol(semanticCastToS31)]
  syntax S31 ::= "S31::(" S31 ")" [symbol(syntacticCastToS31)]
  syntax S31 ::= "S31<:(" K ")" [symbol(outerCastToS31)]
  syntax KBott ::= "S31:>(" S31 ")" [symbol(innerCastToS31)]
  syntax S32 ::= "S32:(" S32 ")" [symbol(semanticCastToS32)]
  syntax S32 ::= "S32::(" S32 ")" [symbol(syntacticCastToS32)]
  syntax S32 ::= "S32<:(" K ")" [symbol(outerCastToS32)]
  syntax KBott ::= "S32:>(" S32 ")" [symbol(innerCastToS32)]
  syntax S33 ::= "S33:(" S33 ")" [symbol(semanticCastToS33)]
  syntax S33 ::= "S33::(" S33 ")" [symbol(syntacticCastToS33)]
  syntax S33 ::= "S33<:(" K ")" [symbol(outerCastToS33)]
  syntax KBott ::= "S33:>(" S33 ")" [symbol(innerCastToS33)]
  syntax S34 ::= "S34:(" S34 ")" [symbol(semanticCastToS34)]
  syntax S34 ::= "S34::(" S34 ")" [symbol(syntacticCastToS34)]
  syntax S34 ::= "S34<:(" K ")" [symbol(outerCastToS34)]
  syntax KBott ::= "S34:>(" S34 ")" [symbol(innerCastToS34)]
  syntax S35 ::= "S35:(" S35 ")" [symbol(semanticCastToS35)]
  syntax S35 ::= "S35::(" S35 ")" [symbol(syntacticCastToS35)]
  syntax S35 ::= "S35<:(" K ")" [symbol(outerCastToS35)]
  syntax KBott ::= "S35:>(" S35 ")" [symbol(innerCastToS35)]
  syntax S36 ::= "S36:(" S36 ")" [symbol(semanticCastToS36)]
  syntax S36 ::= "S36::(" S36 ")" [symbol(syntacticCastToS36)]
  syntax S36 ::= "S36<:(" K ")" [symbol(outerCastToS36)]
  syntax KBott ::= "S36:>(" S36 ")" [symbol(innerCastToS36)]
  syntax S37 ::= "S37:(" S37 ")" [symbol(semanticCastToS37)]
  syntax S37 ::= "S37::(" S37 ")" [symbol(syntacticCastToS37)]
  syntax S37 ::= "S37<:(" K ")" [symbol(outerCastToS37)]
  syntax KBott ::= "S37:>(" S37 ")" [symbol(innerCastToS37)]
  syntax S38 ::= "S38:(" S38 ")" [symbol(semanticCastToS38)]
  syntax S38 ::= "S38::(" S38 ")" [symbol(syntacticCastToS38)]
  syntax S38 ::= "S38<:(" K ")" [symbol(outerCastToS38)]
  syntax KBott ::= "S38:>(" S38 ")" [symbol(innerCastToS38)]
  syntax S39 ::= "S39:(" S39 ")" [symbol(semanticCastToS39)]
  syntax S39 ::= "S39::(" S39 ")" [symbol(syntacticCastToS39)]
  syntax S39 ::= "S39<:(" K ")" [symbol(outerCastToS39)]
  syntax KBott ::= "S39:>(" S39 ")" [symbol(innerCastToS39)]
  syntax S40 ::= "S40:(" S40 ")" [symbol(semanticCastToS40)]
  syntax S40 ::= "S40::(" S40 ")" [symbol(syntacticCastToS40)]
  syntax S40 ::= "S40<:(" K ")" [symbol(outerCastToS40)]
  syntax KBott ::= "S40:>(" S40 ")" [symbol(innerCastToS40)]
  syntax S41 ::= "S41:(" S41 ")" [symbol(semanticCastToS41)]
  syntax S41 ::= "S41::(" S41 ")" [symbol(syntacticCastToS41)]
  syntax S41 ::= "S41<:(" K ")" [symbol(outerCastToS41)]
  syntax KBott ::= "S41:>(" S41 ")" [symbol(innerCastToS41)]
  syntax S42 ::= "S42:(" S42 ")" [symbol(semanticCastToS42)]
  syntax S42 ::= "S42::(" S42 ")" [symbol(syntacticCastToS42)]
  syntax S42 ::= "S42<:(" K ")" [symbol(outerCastToS42)]
  syntax KBott ::= "S42:>(" S42 ")" [symbol(innerCastToS42)]
  syntax S43 ::= "S43:(" S43 ")" [symbol(semanticCastToS43)]
  syntax S43 ::= "S43::(" S43 ")" [symbol(syntacticCastToS43)]
  syntax S43 ::= "S43<:(" K ")" [symbol(outerCastToS43)]
  syntax KBott ::= "S43:>(" S43 ")" [symbol(innerCastToS43)]
  syntax S44 ::= "S44:(" S44 ")" [symbol(semanticCastToS44)]
  syntax S44 ::= "S44::(" S44 ")" [symbol(syntacticCastToS44)]
  syntax S44 ::= "S44<:(" K ")" [symbol(outerCastToS44)]
  syntax KBott ::= "S44:>(" S44 ")" [symbol(innerCastToS44)]
  syntax S45 ::= "S45:(" S45 ")" [symbol(semanticCastToS45)]
  syntax S45 ::= "S45::(" S45 ")" [symbol(syntacticCastToS45)]
  syntax S45 ::= "S45<:(" K ")" [symbol(outerCastToS45)]
  syntax KBott ::= "S45:>(" S45 ")" [symbol(innerCastToS45)]
  syntax S46 ::= "S46:(" S46 ")" [symbol(semanticCastToS46)]
  syntax S46 ::= "S46::(" S46 ")" [symbol(syntacticCastToS46)]
  syntax S46 ::= "S46<:(" K ")" [symbol(outerCastToS46)]
  syntax KBott ::= "S46:>(" S46 ")" [symbol(innerCastToS46)]
  syntax S47 ::= "S47:(" S47 ")" [symbol(semanticCastToS47)]
  syntax S47 ::= "S47::(" S47 ")" [symbol(syntacticCastToS47)]
  syntax S47 ::= "S47<:(" K ")" [symbol(outerCastToS47)]
  syntax KBott ::= "S47:>(" S47 ")" [symbol(innerCastToS47)]
  syntax S48 ::= "S48:(" S48 ")" [symbol(semanticCastToS48)]
  syntax S48 ::= "S48::(" S48 ")" [symbol(syntacticCastToS48)]
  syntax S48 ::= "S48<:(" K ")" [symbol(outerCastToS48)]
  syntax KBott ::= "S48:>(" S48 ")" [symbol(innerCastToS48)]
  syntax S49 ::= "S49:(" S49 ")" [symbol(semanticCastToS49)]
  syntax S49 ::= "S49::(" S49 ")" [symbol(syntacticCastToS49)]
  syntax S49 ::= "S49<:(" K ")" [symbol(outerCastToS49)]
  syntax KBott ::= "S49:>(" S49 ")" [symbol(innerCastToS49)]

endmodule

module S0050
  imports PREDEF
  imports CASTS

  syntax S
  syntax S ::= "S:(" S ")" [symbol(semanticCastToS)]
  syntax S ::= "S::(" S ")" [symbol(syntacticCastToS)]
  syntax S ::= "S<:(" K ")" [symbol(outerCastToS)]
  syntax KBott ::= "S:>(" S ")" [symbol(innerCastToS)]

  rule S:>(A) => S:>(B)
  rule S:>(A) => S:>(B)
  rule S:>(A) => S:>(B)
  rule S:>(A) => S:>(B)
  rule S:>(A) => S:>(B)
  rule S:>(A) => S:>(B)
  rule S:>(A) => S:>(B)
  rule S:>(A) => S:>(B)
  rule S:>(A) => S:>(B)
  rule S:>(A) => S:>(B)

endmodule
