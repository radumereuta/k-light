// written by Radu Mereuta
// should be run with K5
// used to disambiguate imp rules in the KORE format
require "kore.k"

module IMP-DISAMB-SYNTAX
imports KORE-SYNTAX


endmodule

module IMP-DISAMB
imports KORE

// labels
syntax Name ::= "cast"  [token, prec(2)]
syntax Name ::= "array" [token, prec(2)]
syntax Name ::= "mul"   [token, prec(2)]
syntax Name ::= "plus"  [token, prec(2)]
syntax Name ::= "rew"   [token, prec(2)]

// sorts
syntax Name ::= "Exp"  [token, prec(2)]

// priorities: cast > * > + > rew
rule cast{_}(plus{_}(_))  => \bottom{Exp{.Sorts}}() [anywhere]
rule cast{_}(mul {_}(_))  => \bottom{Exp{.Sorts}}() [anywhere]
rule cast{_}(rew{_}(_))   => \bottom{Exp{.Sorts}}() [anywhere]

rule array{_}(plus{_}(_),_) => \bottom{Exp{.Sorts}}() [anywhere]
rule array{_}(mul {_}(_),_) => \bottom{Exp{.Sorts}}() [anywhere]

rule mul{_}(plus{_}(_),_) => \bottom{Exp{.Sorts}}() [anywhere]
rule mul{_}(_,plus{_}(_)) => \bottom{Exp{.Sorts}}() [anywhere]

rule mul{_}(rew{_}(_),_) => \bottom{Exp{.Sorts}}() [anywhere]
rule mul{_}(_,rew{_}(_)) => \bottom{Exp{.Sorts}}() [anywhere]

rule plus{_}(rew{_}(_),_) => \bottom{Exp{.Sorts}}() [anywhere]
rule plus{_}(_,rew{_}(_)) => \bottom{Exp{.Sorts}}() [anywhere]
rule plus{_}(inj{_}(rew{_}(_)),_) => \bottom{Exp{.Sorts}}() [anywhere] // TODO: change this, because
rule plus{_}(_,inj{_}(rew{_}(_))) => \bottom{Exp{.Sorts}}() [anywhere] // the agressive axiom can apply backwards

rule array{_}(rew{_}(_),_) => \bottom{Exp{.Sorts}}() [anywhere]

// associativity
rule plus{_}(_,plus{_}(_)) => \bottom{Exp{.Sorts}}() [anywhere]
rule mul {_}(_,mul {_}(_)) => \bottom{Exp{.Sorts}}() [anywhere]

// injection propagation over parametric symbols
rule rew{S2}(inj{S1,S2}(A),inj{S1,S2}(B)) => inj{S1,S2}(rew{S1}(A, B)) [anywhere] // the agressive axiom implemented as a rule

// TODO: disambiguate casts and rewrites

endmodule
