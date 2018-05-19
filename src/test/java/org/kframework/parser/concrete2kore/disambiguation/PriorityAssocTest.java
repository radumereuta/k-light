// Copyright (c) 2015-2016 K Team. All Rights Reserved.

package org.kframework.parser.concrete2kore.disambiguation;

import org.junit.Test;
import org.kframework.attributes.Source;
import org.kframework.parser.concrete2kore.ParserUtils;
import org.kframework.treeNodes.Term;
import static org.kframework.definition.Constructors.Sort;


public class PriorityAssocTest {


    @Test
    public void testPriorityAssoc() throws Exception {
        String def = "module TEST " +
                "syntax Exp ::= Exp \"*\" Exp [left, symbol('Mul)] " +
                "> Exp \"+\" Exp [left, symbol('Plus)] " +
                "| r\"[0-9]+\" [token] " +
                "syntax left 'Plus " +
                "syntax left 'Mul " +
                "endmodule";
        Term out1 = ParserUtils.parseWithString("1+2", "TEST", Sort("Exp"), Source.apply("generated by PriorityAssocTest"), def);
        //System.out.println("out1 = " + out1);
        Term out2 = ParserUtils.parseWithString("1+2*3", "TEST", Sort("Exp"), Source.apply("generated by PriorityAssocTest"), def);
        //System.out.println("out2 = " + out2);
        Term out3 = ParserUtils.parseWithString("1+2+3", "TEST", Sort("Exp"), Source.apply("generated by PriorityAssocTest"), def);
        //System.out.println("out3 = " + out3);
    }
}
