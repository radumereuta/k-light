// written by Radu Mereuta
// should be run with K5
// used to disambiguate small and simple rules in the KORE format
require "../kore.k"

module SMALL-SHARED-SYNTAX
imports KORE-SYNTAX


endmodule

module SMALL-SHARED
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

syntax Pattern ::= visittd(Pattern, Map)
syntax KBott   ::= visittd1(K)
syntax Pattern ::= visittdLeft(Pattern, Map, Name)
syntax Pattern ::= visittdRight(Pattern, Map, Name)
syntax Pattern ::= visitbu(Pattern, Map)

// module propagation
rule visittd1(A:Attribute M:Modules) => A visittd1(M) [anywhere]
rule visittd1(`moduleList`(M:Module, Ms)) => `moduleList`(visittd1(M), visittd1(Ms)) [anywhere]
rule visittd1(.Modules) => .Modules [anywhere]

rule visittd1(`module`(N:Name, D:Declarations, A:Attribute)) => `module`(N, visittd1(D), A) [anywhere]
rule visittd1(declList(D, Ds)) => declList(visittd1(D), visittd1(Ds)) [anywhere]
rule visittd1(.Declarations) => .Declarations [anywhere]

rule visittd1(import N A) => import N A [anywhere]
rule visittd1(sort N { Na } A) => visittd1(sort N { Na } A) [anywhere]
rule visittd1(symbol N { Na } ( Ss ) : S A) => symbol N { Na } ( Ss ) : S A [anywhere]

rule visittd1(axiom {S} Pt A) => axiom {S} visittd(Pt, .Map) A [anywhere]
rule axiom {S} visitbu(Pt, M) A => axiom {S} Pt A [anywhere]

// pattern propagation
rule visittd(\exists{S1}(Var:S2,Pt), M) => \exists{S1}(Var:S2, visittd(Pt, M)) [anywhere]
rule \exists{S1}(Var:S2, visitbu(Pt, M)) => visitbu(\exists{S1}(Var:S2, Pt), M) [anywhere]
rule visittd(\and{S}(\equals{S1,S2}(Var:S1,Pte), Pta), M) => \and{S}(\equals{S1,S2}(Var:S1, Pte), visittd(Pta, M Var |-> Pte)) [anywhere]
rule \and{S}(\equals{S1,S2}(Var:S1,Pte), visitbu(Pta, M)) => visitbu(\and{S}(\equals{S1,S2}(Var:S1, Pte), Pta), M) [anywhere]

// interesting propagation

rule visittd(kcell{S}(Pt:Pattern), M) => kcell{S}(visittd(Pt, M)) [anywhere]
rule kcell{S}(visitbu(Pt:Pattern, M)) => visitbu(kcell{S}(Pt), M) [anywhere]
rule visittd(inj{S1, S2}(Pt:Pattern), M) => inj{S1, S2}(visittd(Pt, M)) [anywhere]
rule inj{S1, S2}(visitbu(Pt:Pattern, M)) => visitbu(inj{S1, S2}(Pt), M) [anywhere]
rule visittd(\or{S}(Pt1, Pt2), M) => \or{S}(visittd(Pt1, M), Pt2) [anywhere]

rule \or{S}(visitbu(Pt1, M), Pt2) => \or{S}(Pt1, visittd(Pt2, M)) [anywhere]

rule visittd(mul{S}(Pt1, Pt2), M) => mul{S}(visittdLeft(Pt1, M, mul), Pt2) [anywhere]
rule visittdLeft(plus{_}(_), M, mul) => visitbu(\bottom{Exp{.Sorts}}(), M) [anywhere]
rule mul{S}(visitbu(Pt1, M), Pt2) =>  mul{S}(Pt1, visittdRight(Pt2, M, mul)) [anywhere]
rule visittdRight(plus{_}(_), M, mul) => visitbu(\bottom{Exp{.Sorts}}(), M) [anywhere]
rule visittdRight(P, M, mul) => visitbu(P, M) [anywhere, owise]
rule mul{S}(Pt1, visitbu(Pt2, M)) =>  visitbu(mul{S}(Pt1, Pt2), M) [anywhere]

rule visittd(plus{S}(Pt1, Pt2), M) => plus{S}(visittd(Pt1, M), Pt2) [anywhere]
rule plus{S}(visitbu(Pt1, M), Pt2) => plus{S}(Pt1, visittd(Pt2, M)) [anywhere]
rule plus{S}(Pt1, visitbu(Pt2, M)) => visitbu(plus{S}(Pt1, Pt2), M) [anywhere]

rule visittd(V : S, M) => visitbu(V : S, M) [anywhere]
rule visittd(\dv{S}(V), M) => visitbu(\dv{S}(V), M) [anywhere]

rule visittdLeft(V : S, V |-> Pt M, N) => visittdLeft(Pt, V |-> Pt M, N) [anywhere]
rule visittdRight(V : S, V |-> Pt M, N) => visittdRight(Pt, V |-> Pt M, N) [anywhere]

rule visittdLeft(inj{S1, S2}(Pt), M, N) => inj{S1, S2}(visittdLeft(Pt, M, N)) [anywhere]
rule visittdRight(inj{S1, S2}(Pt), M, N) => inj{S1, S2}(visittdRight(Pt, M, N)) [anywhere]


rule patternList(S, \bottom{Exp{.Sorts}}()) => patternList(\bottom{Exp{.Sorts}}())  [anywhere]
rule symbolParams(_, patternList(\bottom{Exp{.Sorts}}(), _)) => \bottom{Exp{.Sorts}}() [anywhere]

//rule mul{_}(plus{_}(_),_) => \bottom{Exp{.Sorts}}() [anywhere]
//rule mul{_}(_,plus{_}(_)) => \bottom{Exp{.Sorts}}() [anywhere]


endmodule
