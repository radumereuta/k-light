# Disambiguation rules
This contains the disambiguation rewrite rules for a small arithmetic language.
No sharing for the terms at this moment. All rewriting is done using anywhere rules.

IMP produces terms which are too large to represent as trees, so the only option is with sharing,
but the shared representation would complicate the disambiguation rules too much for now.

# Structure
- *kore.k* contains the grammar (written in K5) for parsing a complete kore file (modules, symbols and axioms)
- *small/small-disamb.k* extends kore.k with disambiguation rules for a small expression language. This is done over the tree representation of the terms for simplicity.
- *small/examples/small.k* is a small expression language written for the K4 (k-light) parser which outputs the KORE representation of the parsed terms.
- *imp/imp-disamb.k* extends kore.k with disambiguation rules for the IMP language (work in progress). This can only be done over the DAG because the tree is too big.
- *imp/examples/imp-rules-typed.k* the rules of IMP with the complete rules grammar (written by hand) for the K4 parser (k-light) parser which outputs the KORE representation of the parsed terms. All the variables inside rules are typed in all occurances for easier disambiguation.
