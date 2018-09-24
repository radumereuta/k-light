# outer-k.k
Is a grammar of K4-K5 written in K4 that takes as input a full K definition.
This includes modules, syntax declarations and rules with any contents.

In the tests folder is the IMP definition translated into AST KORE.

It iis intended to be used in k-in-k for testing purposes.

Note: the K4 parser (extracted as a standalone in k-light) uses a scanerless parser. The K5 parser (for performance reasons) uses flex as a separate scanner.
This means token declarations can differ sometimes in syntax and semantics.
