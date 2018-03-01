// Copyright (c) 2015-2016 K Team. All Rights Reserved.
package org.kframework.parser.concrete2kore;

import com.beust.jcommander.internal.Lists;
import dk.brics.automaton.Automaton;
import dk.brics.automaton.RegExp;
import dk.brics.automaton.RunAutomaton;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.kframework.attributes.Source;
import org.kframework.definition.Definition;
import org.kframework.definition.Module;
import org.kframework.definition.RegexTerminal;
import org.kframework.frontend.convertors.KILtoKORE;
import org.kframework.parser.concrete2kore.generator.RuleGrammarGenerator;
import org.kframework.treeNodes.Term;
import org.kframework.utils.FileUtil;
import org.kframework.utils.GlobalOptions;
import org.kframework.utils.errorsystem.KExceptionManager;
import org.kframework.utils.errorsystem.ParseFailedException;
import scala.Tuple2;
import scala.util.Either;

import java.util.Set;

import static org.kframework.definition.Constructors.Sort;

public class RuleGrammarTest {

    ParserUtils defParser;

    @Before
    public void setUp() throws Exception {
        defParser = new ParserUtils(FileUtil.testFileUtil()::resolveWorkingDirectory, new KExceptionManager(new GlobalOptions()));
    }

    private void parseProgram(String input, String def, String startSymbol, int warnings, boolean expectedError) {
        Definition baseK = defParser.loadDefinition("TEST", "TEST", def, new Source("RuleGrammarTest"), Lists.newArrayList());
        Module test = baseK.getModule("TEST").get();
        ParseInModule parser = RuleGrammarGenerator.getCombinedGrammar(RuleGrammarGenerator.getProgramsGrammar(test, baseK));
        Tuple2<Either<Set<ParseFailedException>, Term>, Set<ParseFailedException>> rule = parser.parseString(input, Sort(startSymbol), Source.apply("generated by RuleGrammarTest"));
        printout(rule, warnings, expectedError);
    }

    private void printout(Tuple2<Either<Set<ParseFailedException>, Term>, Set<ParseFailedException>> rule, int warnings, boolean expectedError) {
        if (false) { // true to print detailed results
            KExceptionManager kem = new KExceptionManager(new GlobalOptions(true, GlobalOptions.Warnings.ALL, true));
            if (rule._1().isLeft()) {
                for (ParseFailedException x : rule._1().left().get()) {
                    kem.addKException(x.getKException());
                }
            } else {
                System.err.println("rule = " + rule._1().right().get());
            }
            for (ParseFailedException x : rule._2()) {
                kem.addKException(x.getKException());
            }
            kem.print();
        }
        if (expectedError)
            Assert.assertTrue("Expected error here: ", rule._1().isLeft());
        else
            Assert.assertTrue("Expected no errors here: ", rule._1().isRight());
        Assert.assertEquals("Expected " + warnings + " warnings: ", warnings, rule._2().size());
    }

    // test lexical to RegexTerminal extractor
    @Test
    public void test16() {
        assertPatterns("", "#", "", "#");
        assertPatterns("abc", "#", "abc", "#");
        assertPatterns("(?<!abc)", "abc", "", "#");
        assertPatterns("(?<!abc)def", "abc", "def", "#");
        assertPatterns("(?<!abcdef", "#", "(?<!abcdef", "#");
        assertPatterns("(?!abc)", "#", "", "abc");
        assertPatterns("\\(?!abc)", "#", "\\(?!abc)", "#");
    }

    private static void assertPatterns(String original, String precede, String pattern, String follow) {
        RegexTerminal re1 = KILtoKORE.getRegexTerminal(original);
        Assert.assertEquals(precede, re1.precedeRegex());
        Assert.assertEquals(pattern, re1.regex());
        Assert.assertEquals(follow, re1.followRegex());
    }

    // test the new regex engine
    @Test
    public void test17() {
        Automaton a = new RegExp("(\\#[^\n\r]*)").toAutomaton();
        RunAutomaton ra = new RunAutomaton(a, false);
        Assert.assertTrue(ra.run("# asf"));
    }

    // test user lists
    @Test
    public void test20() {
        String def = "" +
                "module TEST " +
                "syntax Exp ::= Int \"(\" Ints  \")\" " +
                "syntax Exp ::= Int \"[\" Ints2 \"]\" " +
                "syntax Ints  ::=   List{Int, \",\"} " +
                "syntax Ints2 ::= NeList{Int, \".\"} " +
                "syntax Int ::= r\"[0-9]+\" [token] " +
                "endmodule";
        parseProgram("0, 1, 2", def, "Ints", 0, false);
        parseProgram("0()", def, "Exp", 0, false);
        parseProgram("0[]", def, "Exp", 0, true);
    }

    // test user lists
    @Test
    public void test27() {
        String def = "" +
                "module TEST " +
                "syntax Id  ::=  r\"[a-z]+\" [token, reject2(int)] " +
                "syntax Id  ::=  \"int\" " +
                "endmodule";
        parseProgram("int", def, "Id", 0, false);
    }
}
