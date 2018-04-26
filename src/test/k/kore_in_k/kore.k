module TEST 
syntax #Layout ::= r"(/\\*([^\\*]|(\\*+([^\\*/])))*\\*+/|//[^\n\r]*|[\\ \n\r\t])*"

syntax SortName ::= r"[A-Z][a-zA-Z0-9]*" [token]
syntax Sort ::= SortName "{" SortList "}" [klabel(sort)]
syntax SortList ::= "" [klabel(empty)]
                  | NeSortList
syntax NeSortList ::= Sort
                    | Sort "," NeSortList

syntax Int ::= r"[\\+\\-]?[0-9]+" [token]
syntax String ::= r"[\\\"](([^\\\"\n\r\\\\])|([\\\\][nrtf\\\"\\\\]))*[\\\"]" [token]
                | String "+String" String [right, klabel(stringAdd)]
                | "input" "(" Int "," Int ")" [klabel(input)]
syntax VarName ::= r"[a-zA-Z][a-zA-Z0-9]*" [token]

syntax Exp ::= String
             | VarName ":" Sort [klabel(var)]
             | SymbolName "{" SortList "}" "(" ExpList ")" [klabel(symbol)]
             | "(" Exp ")" [bracket]
             | Exp "="   Exp [klabel(\equals), non-assoc]
             > Exp "/\\" Exp [klabel(\and), right]
             > Exp "\\/" Exp [klabel(\or), right]

syntax ExpList ::= "" [klabel(empty)]
                 | NeExpList
syntax NeExpList ::= Exp
                   | Exp "," NeExpList
syntax SymbolName ::= r"[\\\\]?[a-z][a-zA-Z0-9]*" [token]

syntax Start ::= Exp // start symbol

endmodule
