// written by Radu Mereuta
// should be run with K5
// used to disambiguate IMP rules in the KORE format
require "../kore.k"

module IMP-DISAMB-SYNTAX
imports KORE-SYNTAX


endmodule

module IMP-DISAMB
imports KORE

// labels
syntax Name ::= "cast"  [token, prec(2)]
syntax Name ::= "rew"   [token, prec(2)]

// TODO:
// sorts

// priorities: cast > * > + > rew
// associativity

endmodule
