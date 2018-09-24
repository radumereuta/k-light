# outer.k
Is a grammar written in K4 that takes as input a full K definition.
This includes modules, syntax declarations and rules with KORE contents, so parsing can be done in one step.
Sorts are parametric.

In the tests folder there are a few examples which include a variety of productions.

The *.k files are the input.
The *.kore files contain a simple translation from K to full KORE. No checks are being performed. Translation is in `TreeNodesToOuterKORE.scala`.
The *.kore2 files contain a one to one translation from K to AST KORE. This should be something similar to the meta level representation of a definition.

These are intended to be used in k-in-k for testing purposes.

Note: the K4 parser (extracted as a standalone in k-light) uses a scanerless parser. The K5 parser (for performance reasons) uses flex as a separate scanner.
This means token declarations can differ sometimes in syntax and semantics.
