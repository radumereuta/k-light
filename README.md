# k-light
This is a stripped down version of the K parser. Minimum required code to parse programs.

Contains:
- kernel of the parser
- input helpers: javacc, old outer KIL, scala outer classes, soundness checkers
- translator from kore to kernel DFA structure
- disambiguation filters: assoc, priorities, prefer
- various unit tests

Usage:
- run org.kframework.ctests.Main

Build:
- using maven

Edit:
- using IntelliJ - import maven project
