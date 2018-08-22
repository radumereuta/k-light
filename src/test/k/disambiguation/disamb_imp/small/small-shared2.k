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
syntax Pattern ::= visitbu(Pattern, Map)            // return marker for first visitor
syntax Pattern ::= visittdLeft(Pattern, Map, Name)  [function] // marker for left check
syntax Pattern ::= visittdRight(Pattern, Map, Name) [function] // marker for right check
syntax Pattern ::= visitbu2(Pattern, Map)                      // return marker for checker

// module propagation
rule visittd1(A:Attribute M:Modules) => A visittd1(M)
rule visittd1(`moduleList`(M:Module, Ms)) => `moduleList`(visittd1(M), visittd1(Ms))
rule visittd1(.Modules) => .Modules

rule visittd1(`module`(N:Name, D:Declarations, A:Attribute)) => `module`(N, visittd1(D), A)
rule visittd1(declList(D, Ds)) => declList(visittd1(D), visittd1(Ds))
rule visittd1(.Declarations) => .Declarations

rule visittd1(import N A) => import N A
rule visittd1(sort N { Na } A) => visittd1(sort N { Na } A)
rule visittd1(symbol N { Na } ( Ss ) : S A) => symbol N { Na } ( Ss ) : S A

rule visittd1(axiom {S} Pt A) => axiom {S} visittd(Pt, .Map) A
rule axiom {S} visitbu(Pt, M) A => axiom {S} Pt A [anywhere]

// pattern propagation
rule visittd(\exists{S1}(Var:S2,Pt), M) => \exists{S1}(Var:S2, visittd(Pt, M))
rule \exists{S1}(Var:S2, visitbu(Pt, M)) => visitbu(\exists{S1}(Var:S2, Pt), M) [anywhere]
rule visittd(\and{S}(\equals{S1,S2}(Var:S1,Pte), Pta), M) => \and{S}(\equals{S1,S2}(Var:S1, Pte), visittd(Pta, M Var |-> Pte))
rule \and{S}(\equals{S1,S2}(Var:S1,Pte), visitbu(Pta, M)) => visitbu(\and{S}(\equals{S1,S2}(Var:S1, Pte), Pta), M) [anywhere]

// interesting propagation

rule visittd(kcell{S}(Pt:Pattern), M) => kcell{S}(visittd(Pt, M))
rule kcell{S}(visitbu(Pt:Pattern, M)) => visitbu(kcell{S}(Pt), M) [anywhere]
rule visittd(inj{S1, S2}(Pt:Pattern), M) => inj{S1, S2}(visittd(Pt, M))
rule inj{S1, S2}(visitbu(Pt:Pattern, M)) => visitbu(inj{S1, S2}(Pt), M) [anywhere]
rule visittd(\or{S}(Pt1, Pt2), M) => \or{S}(visittd(Pt1, M), Pt2)

rule \or{S}(visitbu(Pt1, M), Pt2) => \or{S}(Pt1, visittd(Pt2, M)) [anywhere]
rule \or{S}(Pt1, visitbu(Pt2, M)) => visitbu(\or{S}(Pt1, Pt2), M) [anywhere]

// mul
rule visittd(mul{S}(Pt1, Pt2), M) => mul{S}(visittdLeft(Pt1, M, mul), Pt2)
rule visittdLeft(plus{_}(_), M, mul) => visitbu(\bottom{Exp{.Sorts}}(), M)  // * > +
rule mul{S}(visitbu(Pt1, M), Pt2) =>  mul{S}(Pt1, visittdRight(Pt2, M, mul)) [anywhere]
rule visittdRight(plus{_}(_), M, mul) => visitbu(\bottom{Exp{.Sorts}}(), M) // * > +
rule visittdRight(mul{_}(_), M, mul) => visitbu(\bottom{Exp{.Sorts}}(), M)  // left assoc
rule mul{S}(Pt1, visitbu(Pt2, M)) =>  visitbu(mul{S}(Pt1, Pt2), M) [anywhere]

// TODO: same for plus - and try to find a generic way to write the visitors



rule visittdRight(P, M, _) => visitbu(P, M) [owise] // default visited
rule visittdLeft(P, M, _) => visitbu(P, M) [owise]

rule visittd(V : S, M) => visitbu(V : S, M)
rule visittd(\dv{S}(V), M) => visitbu(\dv{S}(V), M)

rule visittdLeft(V : S, V |-> Pt M, N) => visittdLeft(Pt, V |-> Pt M, N)
rule visittdRight(V : S, V |-> Pt M, N) => visittdRight(Pt, V |-> Pt M, N)

rule visittdLeft(inj{S1, S2}(Pt), M, N) => inj{S1, S2}(visittdLeft(Pt, M, N))
rule visittdRight(inj{S1, S2}(Pt), M, N) => inj{S1, S2}(visittdRight(Pt, M, N))

rule visittdLeft(\or{S}(Pt1, Pt2), M, N) => \or{S}(visittdLeft(Pt1, M, N), visittdLeft(Pt2, M, N))
rule visittdRight(\or{S}(Pt1, Pt2), M, N) => \or{S}(visittdRight(Pt1, M, N), visittdRight(Pt2, M, N))

rule patternList(S, \bottom{S}()) => \bottom{S}()  [anywhere]
rule symbolParams(_, patternList(\bottom{S}(), _)) => \bottom{S}() [anywhere]

//rule mul{_}(plus{_}(_),_) => \bottom{Exp{.Sorts}}() [anywhere]
//rule mul{_}(_,plus{_}(_)) => \bottom{Exp{.Sorts}}() [anywhere]


endmodule
