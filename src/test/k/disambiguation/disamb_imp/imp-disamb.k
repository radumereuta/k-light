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
syntax Name ::= "mul"  [token, prec(2)]
syntax Name ::= "plus" [token, prec(2)]
// sorts
syntax Name ::= "Exp"  [token, prec(2)]

// priority mul > plus
rule mul{_}(plus{_}(_),_) => \bottom{Exp{.Sorts}}() [anywhere]
rule mul{_}(_,plus{_}(_)) => \bottom{Exp{.Sorts}}() [anywhere]

// TODO: disambiguate casts and rewrites

endmodule
