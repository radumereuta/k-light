// written by Radu Mereuta
// should be run with K5
// used to disambiguate IMP rules in the KORE format
require "../kore.k"

module IMP-DISAMB-SYNTAX
imports KORE-SYNTAX

endmodule

module IMP-DISAMB
imports KORE
imports MAP

configuration <T> <k> visittd1($PGM:Definition) </k> </T>

syntax Name ::= "inj"   [token, prec(2)]

// top-down visitor markers
syntax KBott   ::= visittd1(K)           [function] // used for outer symbols
syntax Pattern ::= visittd(Pattern, Map) [function] // used inside an axiom
syntax Patterns ::= visittd2(Patterns, Map) [function] // default propagation
syntax Pattern ::= visittdLeft (Pattern, Map, Name) [function] // marker for left check
syntax Pattern ::= visittdRight(Pattern, Map, Name) [function] // marker for right check
syntax Pattern ::= visitbu(Pattern, Map)                       // return marker for checker

// module propagation
rule visittd1(A:Attribute M:Modules) => A visittd1(M)
rule visittd1(`moduleList`(M:Module, Ms)) => `moduleList`(visittd1(M), visittd1(Ms))
rule visittd1(.Modules) => .Modules

rule visittd1(`module`(N:Name, D:Declarations, A:Attribute)) => `module`(N, visittd1(D), A)
rule visittd1(declList(D, Ds)) => declList(visittd1(D), visittd1(Ds))
rule visittd1(.Declarations) => .Declarations

rule visittd1(import N A) => import N A
rule visittd1(sort N { Na } A) => sort N { Na } A
rule visittd1(symbol N { Na } ( Ss ) : S A) => symbol N { Na } ( Ss ) : S A

rule visittd1(axiom {S} Pt A) => axiom {S} visittd(Pt, .Map) A

// pattern propagation
rule visittd(\exists{S1}(Var:S2,Pt), M) => visittd(Pt, M)
rule visittd(\and{S}(\equals{S1,S2}(Var:S1,Pte), Pta), M) => visittd(Pta, M Var |-> Pte)

rule visittd(N{S}(P), M) => N{S}(visittd2(P, M)) [owise] // other productions not involved in priorities or assoc but we need to go over them
rule visittd2(P:Pattern, Ps:Patterns, M:Map) => visittd(P, M), visittd2(Ps, M)
rule visittd2(.Patterns, M:Map) => .Patterns

// default visited
rule visittdRight(P, M, _) => visitbu(P, M) [owise]
rule visittdLeft(P, M, _)  => visitbu(P, M) [owise]

rule visittd(V : S, V |-> Pt M) => visittd(Pt, V |-> Pt M) // lookup shared term
rule visittd(\bottom{Exp{.Sorts}}(), M) => \bottom{Exp{.Sorts}}() // leaf/end
rule visittd(\dv{S}(V), M) => \dv{S}(V)       // leaf/end

rule visittd(inj{S1, S2}(Pt:Pattern), M) => inj{S1, S2}(visittd(Pt, M))
rule visittd(\or{S}(Pt1, Pt2), M) => \or{S}(visittd(Pt1, M), visittd(Pt2, M))

// shared term lookup
rule visittdLeft(V : S, V |-> Pt M, N) => visittdLeft(Pt, V |-> Pt M, N)
rule visittdRight(V : S, V |-> Pt M, N) => visittdRight(Pt, V |-> Pt M, N)

rule visittdLeft(inj{S1, S2}(Pt), M, N) => inj{S1, S2}(visittdLeft(Pt, M, N))
rule visittdRight(inj{S1, S2}(Pt), M, N) => inj{S1, S2}(visittdRight(Pt, M, N))

rule visittdLeft(\or{S}(Pt1, Pt2), M, N) => \or{S}(visittdLeft(Pt1, M, N), visittdLeft(Pt2, M, N))
rule visittdRight(\or{S}(Pt1, Pt2), M, N) => \or{S}(visittdRight(Pt1, M, N), visittdRight(Pt2, M, N))

rule \or{S}(visitbu(Pt1, M), visitbu(Pt2, M)) => visitbu(\or{S}(Pt1, Pt2), M) [anywhere]
rule inj{S1, S2}(visitbu(Pt, M)) => visitbu(inj{S1, S2}(Pt), M) [anywhere]

// eroneous term propagation upwards
rule patternList(P:Pattern, patternList(\bottom{Exp{.Sorts}}(), L)) => patternList(\bottom{Exp{.Sorts}}(), L)  [anywhere]
rule symbolParams(_, patternList(\bottom{Exp{.Sorts}}(), _)) => \bottom{Exp{.Sorts}}() [anywhere]

// injection propagation over parametric symbols
// problem with this one when I have rew(inj(S1), inj(S2))
//rule rew{S2}(inj{S1,S2}(A),inj{S1,S2}(B)) => inj{S1,S2}(rew{S1}(A, B)) [anywhere] // the agressive axiom implemented as a rule
// so let's try the other way around
rule inj{S1,S2}(rew{S1}(A, B)) => rew{S2}(inj{S1,S2}(A),inj{S1,S2}(B)) [anywhere] // the agressive axiom implemented as a rule
rule inj{S1,S2}(bracket{S1}(A)) => bracket{S2}(inj{S1,S2}(A)) [anywhere] // the agressive axiom implemented as a rule





// term propagation - should be generated from syntax priorities and associativity
syntax Name ::= "kRequires"  [token, prec(2)]
syntax Name ::= "kSequence"  [token, prec(2)]
syntax Name ::= "cast"  [token, prec(2)]
syntax Name ::= "rew"   [token, prec(2)]
syntax Name ::= "bracket"   [token, prec(2)]
syntax Name ::= "div"   [token, prec(2)]
syntax Name ::= "divInt"   [token, prec(2)]
syntax Name ::= "plus"  [token, prec(2)]
syntax Name ::= "plusInt"  [token, prec(2)]
syntax Name ::= "not"   [token, prec(2)]
syntax Name ::= "notBool"   [token, prec(2)]
syntax Name ::= "and"   [token, prec(2)]
syntax Name ::= "lte"   [token, prec(2)]
syntax Name ::= "lteInt"   [token, prec(2)]
syntax Name ::= "consIds"   [token, prec(2)]
syntax Name ::= "boolAnd"   [token, prec(2)]
syntax Name ::= "consStmt"   [token, prec(2)]
syntax Name ::= "emptyBlock" [token, prec(2)]
syntax Name ::= "program" [token, prec(2)]
syntax Name ::= "if" [token, prec(2)]
syntax Name ::= "dotK"  [token, prec(2)]
syntax Name ::= "AExp"   [token, prec(2)] // for inserting bottom
syntax Name ::= "BExp"   [token, prec(2)] // for inserting bottom
syntax Name ::= "Bool"   [token, prec(2)] // for inserting bottom
syntax Name ::= "Int"   [token, prec(2)] // for inserting bottom
syntax Name ::= "Ids"   [token, prec(2)] // for inserting bottom
syntax Name ::= "Stmt"   [token, prec(2)] // for inserting bottom
syntax Name ::= "K"   [token, prec(2)] // for inserting bottom

// cast - from K
rule visittd(cast{S}(Pt), M) => cast{S}(visittdLeft(Pt, M, cast))
rule cast{S}(visitbu(Pt, M)) => cast{S}(visittd(Pt, M)) [anywhere]

rule visittdLeft(  rew{S}(_), M, cast) => visitbu(\bottom{S}(), M) // cast > rew
rule visittdLeft(kRequires{S}(_), M, cast) => visitbu(\bottom{S}(), M) // cast > kRequires

// rew - from K
rule visittd(rew{S}(Pt1, Pt2), M) => rew{S}(visittdLeft(Pt1, M, rew), visittdRight(Pt2, M, rew))
rule rew{S}(visitbu(Pt1, M), visitbu(Pt2, M)) =>  rew{S}(visittd(Pt1, M), visittd(Pt2, M)) [anywhere]

rule visittdLeft (rew{S}(_), M, rew) => visitbu(\bottom{S}(), M) // non-assoc
rule visittdRight(rew{S}(_), M, rew) => visitbu(\bottom{S}(), M) // non-assoc
rule visittdLeft (kRequires{_}(_), M, rew) => visitbu(\bottom{K{.Sorts}}(), M) // rew > kRequires
rule visittdRight(kRequires{_}(_), M, rew) => visitbu(\bottom{K{.Sorts}}(), M) // rew > kRequires

// kSequence - from K
rule visittd(kSequence{S}(Pt1, Pt2), M) => kSequence{S}(visittdLeft(Pt1, M, rew), visittdRight(Pt2, M, rew))
rule kSequence{S}(visitbu(Pt1, M), visitbu(Pt2, M)) =>  kSequence{S}(visittd(Pt1, M), visittd(Pt2, M)) [anywhere]

rule visittdRight(kSequence{_}(_), M, kSequence) => visitbu(\bottom{K{.Sorts}}(), M) // left assoc
rule visittdLeft (rew{S}(_), M, kSequence) => visitbu(\bottom{S}(), M) // rew > kSequence
rule visittdRight(rew{S}(_), M, kSequence) => visitbu(\bottom{S}(), M) // rew > kSequence
rule visittdLeft(kSequence{_}(_), M, cast) => visitbu(\bottom{K{.Sorts}}(), M) // cast > kSequence

// kRequires - from K
rule visittd(kRequires{S}(Pt1, Pt2), M) => kRequires{S}(visittdLeft(Pt1, M, kRequires), visittdRight(Pt2, M, kRequires))
rule kRequires{S}(visitbu(Pt1, M), visitbu(Pt2, M)) =>  kRequires{S}(visittd(Pt1, M), visittd(Pt2, M)) [anywhere]

rule visittdLeft (kRequires{S}(_), M, kRequires) => visitbu(\bottom{S}(), M) // non-assoc
rule visittdRight(kRequires{S}(_), M, kRequires) => visitbu(\bottom{S}(), M) // non-assoc

//---------- from language -----------------//

// divInt
rule visittd(divInt{S}(Pt1, Pt2), M) => divInt{S}(visittdLeft(Pt1, M, divInt), visittdRight(Pt2, M, divInt))
rule divInt{S}(visitbu(Pt1, M), visitbu(Pt2, M)) =>  divInt{S}(visittd(Pt1, M), visittd(Pt2, M)) [anywhere]

rule visittdLeft ( rew{S}(_), M, divInt) => visitbu(\bottom{S}(), M) // /Int > rew
rule visittdRight( rew{S}(_), M, divInt) => visitbu(\bottom{S}(), M) // /Int > rew
rule visittdLeft ( kRequires{_}(_), M, divInt) => visitbu(\bottom{Int{.Sorts}}(), M) // /Int > kRequires
rule visittdRight( kRequires{_}(_), M, divInt) => visitbu(\bottom{Int{.Sorts}}(), M) // /Int > kRequires
rule visittdLeft(divInt{_}(_), M, cast) => visitbu(\bottom{Int{.Sorts}}(), M) // cast > /Int


// div
rule visittd(div{S}(Pt1, Pt2), M) => div{S}(visittdLeft(Pt1, M, div), visittdRight(Pt2, M, div))
rule div{S}(visitbu(Pt1, M), visitbu(Pt2, M)) =>  div{S}(visittd(Pt1, M), visittd(Pt2, M)) [anywhere]

rule visittdLeft (plus{_}(_), M, div) => visitbu(\bottom{AExp{.Sorts}}(), M) // / > +
rule visittdRight(plus{_}(_), M, div) => visitbu(\bottom{AExp{.Sorts}}(), M) // / > +
rule visittdLeft ( rew{S}(_), M, div) => visitbu(\bottom{S}(), M) // / > rew
rule visittdRight( rew{S}(_), M, div) => visitbu(\bottom{S}(), M) // / > rew
rule visittdRight( div{_}(_), M, div) => visitbu(\bottom{AExp{.Sorts}}(), M) // left assoc
rule visittdLeft( div{_}(_), M, cast) => visitbu(\bottom{AExp{.Sorts}}(), M) // cast > /

// plus
rule visittd(plus{S}(Pt1, Pt2), M) => plus{S}(visittdLeft(Pt1, M, plus), visittdRight(Pt2, M, plus))
rule plus{S}(visitbu(Pt1, M), visitbu(Pt2, M)) =>  plus{S}(visittd(Pt1, M), visittd(Pt2, M)) [anywhere]

rule visittdLeft ( rew{S}(_), M, plus) => visitbu(\bottom{S}(), M) // + > rew
rule visittdRight( rew{S}(_), M, plus) => visitbu(\bottom{S}(), M) // + > rew
rule visittdRight(plus{_}(_), M, plus) => visitbu(\bottom{AExp{.Sorts}}(), M) // left assoc
rule visittdLeft(plus{_}(_), M, cast) => visitbu(\bottom{AExp{.Sorts}}(), M) // cast > +

// plusInt
rule visittd(plusInt{S}(Pt1, Pt2), M) => plusInt{S}(visittdLeft(Pt1, M, plusInt), visittdRight(Pt2, M, plusInt))
rule plusInt{S}(visitbu(Pt1, M), visitbu(Pt2, M)) =>  plusInt{S}(visittd(Pt1, M), visittd(Pt2, M)) [anywhere]

rule visittdLeft ( rew{S}(_), M, plusInt) => visitbu(\bottom{S}(), M) // +Int > rew
rule visittdRight( rew{S}(_), M, plusInt) => visitbu(\bottom{S}(), M) // +Int > rew
rule visittdRight(plusInt{_}(_), M, plusInt) => visitbu(\bottom{Int{.Sorts}}(), M) // left assoc
rule visittdLeft(plusInt{_}(_), M, cast) => visitbu(\bottom{Int{.Sorts}}(), M) // cast > +Int

// not
rule visittd(not{S}(Pt), M) => not{S}(visittdRight(Pt, M, not))
rule not{S}(visitbu(Pt, M)) => not{S}(visittd(Pt, M)) [anywhere]

rule visittdRight(and{_}(_), M, not) => visitbu(\bottom{BExp{.Sorts}}(), M) // not > +
rule visittdRight(rew{S}(_), M, not) => visitbu(\bottom{S}(), M) // not > rew
rule visittdLeft(not{_}(_), M, cast) => visitbu(\bottom{BExp{.Sorts}}(), M) // cast > !

// notBool
rule visittd(notBool{S}(Pt), M) => notBool{S}(visittdRight(Pt, M, notBool))
rule notBool{S}(visitbu(Pt, M)) => notBool{S}(visittd(Pt, M)) [anywhere]

rule visittdRight(and{_}(_), M, notBool) => visitbu(\bottom{Bool{.Sorts}}(), M) // notBool > +
rule visittdRight(rew{S}(_), M, notBool) => visitbu(\bottom{S}(), M) // notBool > rew
rule visittdLeft(notBool{_}(_), M, cast) => visitbu(\bottom{Bool{.Sorts}}(), M) // cast > !

// and
rule visittd(and{S}(Pt1, Pt2), M) => and{S}(visittdLeft(Pt1, M, and), visittdRight(Pt2, M, and))
rule and{S}(visitbu(Pt1, M), visitbu(Pt2, M)) =>  and{S}(visittd(Pt1, M), visittd(Pt2, M)) [anywhere]

rule visittdLeft ( rew{S}(_), M, and) => visitbu(\bottom{S}(), M) // && > rew
rule visittdRight( rew{S}(_), M, and) => visitbu(\bottom{S}(), M) // && > rew
rule visittdRight(and{_}(_), M, and) => visitbu(\bottom{BExp{.Sorts}}(), M) // left assoc
rule visittdLeft(and{_}(_), M, cast) => visitbu(\bottom{BExp{.Sorts}}(), M) // cast > &&

// boolAnd
rule visittd(boolAnd{S}(Pt1, Pt2), M) => boolAnd{S}(visittdLeft(Pt1, M, boolAnd), visittdRight(Pt2, M, boolAnd))
rule boolAnd{S}(visitbu(Pt1, M), visitbu(Pt2, M)) =>  boolAnd{S}(visittd(Pt1, M), visittd(Pt2, M)) [anywhere]

rule visittdLeft ( rew{S}(_), M, boolAnd) => visitbu(\bottom{S}(), M) // and > rew
rule visittdRight( rew{S}(_), M, boolAnd) => visitbu(\bottom{S}(), M) // and > rew
rule visittdRight(boolAnd{_}(_), M, boolAnd) => visitbu(\bottom{Bool{.Sorts}}(), M) // left assoc
rule visittdLeft(boolAnd{_}(_), M, cast) => visitbu(\bottom{Bool{.Sorts}}(), M) // cast > and

// lte
rule visittd(lte{S}(Pt1, Pt2), M) => lte{S}(visittdLeft(Pt1, M, lte), visittdRight(Pt2, M, lte))
rule lte{S}(visitbu(Pt1, M), visitbu(Pt2, M)) =>  lte{S}(visittd(Pt1, M), visittd(Pt2, M)) [anywhere]

rule visittdLeft ( rew{S}(_), M, lte) => visitbu(\bottom{S}(), M) // lte > rew
rule visittdRight( rew{S}(_), M, lte) => visitbu(\bottom{S}(), M) // lte > rew
rule visittdLeft(lte{_}(_), M, cast) => visitbu(\bottom{BExp{.Sorts}}(), M) // cast > lte

// lteInt
rule visittd(lteInt{S}(Pt1, Pt2), M) => lteInt{S}(visittdLeft(Pt1, M, lteInt), visittdRight(Pt2, M, lteInt))
rule lteInt{S}(visitbu(Pt1, M), visitbu(Pt2, M)) =>  lteInt{S}(visittd(Pt1, M), visittd(Pt2, M)) [anywhere]

rule visittdLeft ( rew{S}(_), M, lteInt) => visitbu(\bottom{S}(), M) // lteInt > rew
rule visittdRight( rew{S}(_), M, lteInt) => visitbu(\bottom{S}(), M) // lteInt > rew
rule visittdLeft(lteInt{_}(_), M, cast) => visitbu(\bottom{Int{.Sorts}}(), M) // cast > lteInt

// consStmt
rule visittd(consStmt{S}(Pt1, Pt2), M) => consStmt{S}(visittdLeft(Pt1, M, consStmt), visittdRight(Pt2, M, consStmt))
rule consStmt{S}(visitbu(Pt1, M), visitbu(Pt2, M)) =>  consStmt{S}(visittd(Pt1, M), visittd(Pt2, M)) [anywhere]

rule visittdLeft ( rew{S}(_), M, consStmt) => visitbu(\bottom{S}(), M) // consStmt > rew
rule visittdRight( rew{S}(_), M, consStmt) => visitbu(\bottom{S}(), M) // consStmt > rew
rule visittdLeft (kSequence{_}(_), M, consStmt) => visitbu(\bottom{K{.Sorts}}(), M) // consStmt > kSequence
rule visittdRight(kSequence{_}(_), M, consStmt) => visitbu(\bottom{K{.Sorts}}(), M) // consStmt > kSequence
rule visittdLeft(consStmt{_}(_), M, cast) => visitbu(\bottom{Stmt{.Sorts}}(), M) // cast > consStmt

// program
rule visittd(program{S}(Pt1, Pt2), M) => program{S}(Pt1, visittdRight(Pt2, M, program))
rule program{S}(Pt1, visitbu(Pt2, M)) =>  program{S}(visittd(Pt1, M), visittd(Pt2, M)) [anywhere]

rule visittdRight( rew{S}(_), M, program) => visitbu(\bottom{S}(), M) // program > rew
rule visittdLeft(program{_}(_), M, cast) => visitbu(\bottom{Stmt{.Sorts}}(), M) // cast > program

// if
rule visittd(if{S}(Pt1, Pt2, Pt3), M) => if{S}(Pt1, Pt2, visittdRight(Pt3, M, if))
rule if{S}(Pt1, Pt2, visitbu(Pt3, M)) =>  if{S}(visittd(Pt1, M), visittd(Pt2, M), visittd(Pt3, M)) [anywhere]

rule visittdRight( rew{S}(_), M, if) => visitbu(\bottom{S}(), M) // if > rew
rule visittdLeft(if{_}(_), M, cast) => visitbu(\bottom{Stmt{.Sorts}}(), M) // cast > if

// consIds
rule visittd(consIds{S}(Pt1, Pt2), M) => consIds{S}(visittdLeft(Pt1, M, consIds), visittdRight(Pt2, M, consIds))
rule consIds{S}(visitbu(Pt1, M), visitbu(Pt2, M)) =>  consIds{S}(visittd(Pt1, M), visittd(Pt2, M)) [anywhere]

rule visittdLeft ( rew{S}(_), M, consIds) => visitbu(\bottom{S}(), M) // consIds > rew
rule visittdRight( rew{S}(_), M, consIds) => visitbu(\bottom{S}(), M) // consIds > rew
rule visittdLeft(consIds{_}(_), M, cast) => visitbu(\bottom{Ids{.Sorts}}(), M) // cast > consIds



endmodule
