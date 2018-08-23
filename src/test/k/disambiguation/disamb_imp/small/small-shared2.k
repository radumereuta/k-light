// written by Radu Mereuta
// should be run with K5
// used to disambiguate small and simple rules in the KORE format
require "../kore.k"

module SMALL-SHARED2-SYNTAX
imports KORE-SYNTAX


endmodule

module SMALL-SHARED2
imports KORE
imports MAP

configuration <T> <k> visittd1($PGM:Definition) </k> </T>

// labels
syntax Name ::= "cast"  [token, prec(2)]
syntax Name ::= "array" [token, prec(2)]
syntax Name ::= "mul"   [token, prec(2)]
syntax Name ::= "plus"  [token, prec(2)]
syntax Name ::= "rew"   [token, prec(2)]

syntax Name ::= "kcell" [token, prec(2)]
syntax Name ::= "inj"   [token, prec(2)]


// sorts
syntax Name ::= "Exp"  [token, prec(2)]

syntax KBott   ::= visittd1(K)           [function] // used for outer symbols
syntax Pattern ::= visittd(Pattern, Map) [function] // used inside an axiom
syntax Pattern ::= visittdLeft(Pattern, Map, Name)  [function] // marker for left check
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
rule visittd(\exists{S1}(Var:S2,Pt), M) => \exists{S1}(Var:S2, visittd(Pt, M))
rule visittd(\and{S}(\equals{S1,S2}(Var:S1,Pte), Pta), M) => \and{S}(\equals{S1,S2}(Var:S1, Pte), visittd(Pta, M Var |-> Pte))

// interesting propagation

rule visittd(kcell{S}(Pt:Pattern), M) => kcell{S}(visittd(Pt, M))
rule visittd(inj{S1, S2}(Pt:Pattern), M) => inj{S1, S2}(visittd(Pt, M))
rule visittd(\or{S}(Pt1, Pt2), M) => \or{S}(visittd(Pt1, M), visittd(Pt2, M))

// cast
rule visittd(cast{S}(Pt), M) => cast{S}(visittdLeft(Pt, M, cast))
rule cast{S}(visitbu(Pt, M)) =>  cast{S}(visittd(Pt, M)) [anywhere]

rule visittdLeft(array{_}(_), M, cast) => visitbu(\bottom{Exp{.Sorts}}(), M)  // cast > array
rule visittdLeft( plus{_}(_), M, cast) => visitbu(\bottom{Exp{.Sorts}}(), M)  // cast > +
rule visittdLeft(  mul{_}(_), M, cast) => visitbu(\bottom{Exp{.Sorts}}(), M)  // cast > *
rule visittdLeft(  rew{_}(_), M, cast) => visitbu(\bottom{Exp{.Sorts}}(), M)  // cast > rew

// array
rule visittd(array{S}(Pt1, Pt2), M) => array{S}(visittdLeft(Pt1, M, array), Pt2)
rule array{S}(visitbu(Pt1, M), Pt2) =>  array{S}(visittd(Pt1, M), visittd(Pt2, M)) [anywhere]

rule visittdLeft(plus{_}(_), M, array) => visitbu(\bottom{Exp{.Sorts}}(), M)  // array > +
rule visittdLeft( mul{_}(_), M, array) => visitbu(\bottom{Exp{.Sorts}}(), M)  // array > *
rule visittdLeft( rew{_}(_), M, array) => visitbu(\bottom{Exp{.Sorts}}(), M)  // array > rew

// mul
rule visittd(mul{S}(Pt1, Pt2), M) => mul{S}(visittdLeft(Pt1, M, mul), visittdRight(Pt2, M, mul))
rule mul{S}(visitbu(Pt1, M), visitbu(Pt2, M)) =>  mul{S}(visittd(Pt1, M), visittd(Pt2, M)) [anywhere]

rule visittdLeft (plus{_}(_), M, mul) => visitbu(\bottom{Exp{.Sorts}}(), M) // * > +
rule visittdRight(plus{_}(_), M, mul) => visitbu(\bottom{Exp{.Sorts}}(), M) // * > +
rule visittdLeft ( rew{_}(_), M, mul) => visitbu(\bottom{Exp{.Sorts}}(), M) // * > rew
rule visittdRight( rew{_}(_), M, mul) => visitbu(\bottom{Exp{.Sorts}}(), M) // * > rew
rule visittdRight( mul{_}(_), M, mul) => visitbu(\bottom{Exp{.Sorts}}(), M) // left assoc

// plus
rule visittd(plus{S}(Pt1, Pt2), M) => plus{S}(visittdLeft(Pt1, M, plus), visittdRight(Pt2, M, plus))
rule plus{S}(visitbu(Pt1, M), visitbu(Pt2, M)) =>  plus{S}(visittd(Pt1, M), visittd(Pt2, M)) [anywhere]

rule visittdRight(plus{_}(_), M, plus) => visitbu(\bottom{Exp{.Sorts}}(), M)  // left assoc
rule visittdLeft ( rew{_}(_), M, plus) => visitbu(\bottom{Exp{.Sorts}}(), M) // + > rew
rule visittdRight( rew{_}(_), M, plus) => visitbu(\bottom{Exp{.Sorts}}(), M) // + > rew

// rew
rule visittd(rew{S}(Pt1, Pt2), M) => rew{S}(visittdLeft(Pt1, M, rew), visittdRight(Pt2, M, rew))
rule rew{S}(visitbu(Pt1, M), visitbu(Pt2, M)) =>  rew{S}(visittd(Pt1, M), visittd(Pt2, M)) [anywhere]

rule visittdLeft( rew{_}(_), M, rew) => visitbu(\bottom{Exp{.Sorts}}(), M)  // non-assoc
rule visittdRight(rew{_}(_), M, rew) => visitbu(\bottom{Exp{.Sorts}}(), M)  // non-assoc




rule visittdRight(P, M, _) => visitbu(P, M) [owise] // default visited
rule visittdLeft(P, M, _) => visitbu(P, M) [owise]

rule visittd(V : S, V |-> Pt M) => visittd(Pt, V |-> Pt M)
rule visittd(\bottom{S}(), M) => \bottom{S}()
rule visittd(\dv{S}(V), M) => \dv{S}(V)

rule visittdLeft(V : S, V |-> Pt M, N) => visittdLeft(Pt, V |-> Pt M, N)
rule visittdRight(V : S, V |-> Pt M, N) => visittdRight(Pt, V |-> Pt M, N)

rule visittdLeft(inj{S1, S2}(Pt), M, N) => inj{S1, S2}(visittdLeft(Pt, M, N))
rule visittdRight(inj{S1, S2}(Pt), M, N) => inj{S1, S2}(visittdRight(Pt, M, N))

rule visittdLeft(\or{S}(Pt1, Pt2), M, N) => \or{S}(visittdLeft(Pt1, M, N), visittdLeft(Pt2, M, N))
rule visittdRight(\or{S}(Pt1, Pt2), M, N) => \or{S}(visittdRight(Pt1, M, N), visittdRight(Pt2, M, N))

rule \or{S}(visitbu(Pt1, M), visitbu(Pt2, M)) => visitbu(\or{S}(Pt1, Pt2), M) [anywhere]
rule inj{S1, S2}(visitbu(Pt, M)) => visitbu(inj{S1, S2}(Pt), M) [anywhere]

rule patternList(P:Pattern, patternList(\bottom{S}(), L)) => patternList(\bottom{S}(), L)  [anywhere]
rule symbolParams(_, patternList(\bottom{S}(), _)) => \bottom{S}() [anywhere]

// injection propagation over parametric symbols
rule rew{S2}(inj{S1,S2}(A),inj{S1,S2}(B)) => inj{S1,S2}(rew{S1}(A, B)) [anywhere] // the agressive axiom implemented as a rule


endmodule
