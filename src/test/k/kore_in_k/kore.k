module TEST 
syntax #Layout ::= r"(/\\*([^\\*]|(\\*+([^\\*/])))*\\*+/|//[^\n\r]*|[\\ \n\r\t])*"

syntax SortName ::= r"[A-Z][a-zA-Z0-9]*" [token]
syntax Sort ::= SortName "{" SortList "}" [symbol(sort)]
syntax SortList ::= "" [symbol(empty)]
                  | NeSortList
syntax NeSortList ::= Sort
                    | Sort "," NeSortList

syntax Int ::= r"[\\+\\-]?[0-9]+" [token]
syntax String ::= r"[\\\"](([^\\\"\n\r\\\\])|([\\\\][nrtf\\\"\\\\]))*[\\\"]" [token]
                | String "+String" String [right, symbol(stringAdd)]
                | "input" "(" Int "," Int ")" [symbol(input)]
syntax VarName ::= r"[a-zA-Z][a-zA-Z0-9]*" [token]

syntax Exp ::= String
             | VarName ":" Sort [symbol(var)]
             | SymbolName "{" SortList "}" "(" ExpList ")" [symbol(symbol)]
             | "(" Exp ")" [bracket]
             | Exp "="   Exp [symbol(\equals), non-assoc]
             > Exp "/\\" Exp [symbol(\and), right]
             > Exp "\\/" Exp [symbol(\or), right]

syntax ExpList ::= "" [symbol(empty)]
                 | NeExpList
syntax NeExpList ::= Exp
                   | Exp "," NeExpList
syntax SymbolName ::= r"[\\\\]?[a-z][a-zA-Z0-9]*" [token]

syntax Start ::= Exp // start symbol

endmodule
