// Copyright (c) 2015-2016 K Team. All Rights Reserved.
package org.kframework.parser.concrete2kore;

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

import java.util.ArrayList;
import java.util.Set;

import static org.kframework.definition.Constructors.Sort;

public class RuleGrammarTest {

    ParserUtils defParser;

    @Before
    public void setUp() throws Exception {
        defParser = new ParserUtils(FileUtil.testFileUtil()::resolveWorkingDirectory, new KExceptionManager(new GlobalOptions()));
    }

    private void parseProgram(String input, String def, String startSymbol, int warnings, boolean expectedError) {
        Definition baseK = defParser.loadDefinition("TEST", "TEST", def, new Source("RuleGrammarTest"), new ArrayList<>());
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
        Automaton a = new RegExp("((/\\*([^\\*]|(\\*+([^\\*/])))*\\*+/)|(//[^\n\r]*)|([\\ \n\r\t])|(\\#[^\n\r]*)|([\\ \n\r\t]))*").toAutomaton();
        RunAutomaton ra = new RunAutomaton(a, false);
        Assert.assertTrue(ra.run("#abd"));
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
        parseProgram("0,1,2", def, "Ints", 0, false);
        parseProgram("0()", def, "Exp", 0, false);
        parseProgram("0[]", def, "Exp", 0, true);
    }

    // test manual reject
    @Test
    public void test27() {
        String def = "" +
                "module TEST " +
                "syntax Id  ::=  r\"[a-z]+\" [token, reject2(int)] " +
                "syntax Id  ::=  \"int\" " +
                "endmodule";
        parseProgram("int", def, "Id", 0, false);
    }

    // test custom whitespace
    @Test
    public void test28() {
        String def = "" +
                "module TEST " +
                "syntax #Layout ::= r\"([\\\\ \\n\\r\\t])*\" " +
                "syntax Ids ::= List{Id, \",\"} " +
                "syntax Id  ::=  \"a\" " +
                "endmodule";
        parseProgram("  a ", def, "Id", 0, false);
        parseProgram("a,a", def, "Ids", 0, false);
        parseProgram(" a , a ", def, "Ids", 0, false);
        parseProgram(" ", def, "Id", 0, true);
        parseProgram(" ", def, "Ids", 0, false);
    }

    // test custom recursive whitespace
    @Test
    public void test29() {
        String def = "" +
                "module TEST " +
                "syntax #Layout ::= #Layout #LayoutItem " +
                "syntax #Layout ::= \"\" " +
                "syntax #LayoutItem ::= r\"/\\\\*([^\\\\*]|(\\\\*+([^\\\\*/])))*\\\\*+/\" " + // "/\\*([^\\*]|(\\*+([^\\*/])))*\\*+/"
                "syntax #LayoutItem ::= r\"//[^\\n\\r]*\" " +                                 // "//[^\n\r]*"
                "syntax #LayoutItem ::= r\"[\\\\ \\n\\r\\t]*\" " +                            // "[\\ \n\r\t]*"
                "syntax Ids ::= List{Id, \",\"} " +
                "syntax Id  ::=  \"a\" " +
                "endmodule";
        parseProgram("  a ", def, "Id", 0, false);
        parseProgram("//a", def, "Ids", 0, false);
        parseProgram("/*a*/", def, "Ids", 0, false);
        parseProgram("/*a*//*a*//*a*/", def, "Ids", 0, false);
        parseProgram("/*a*/ //asdf\n  ", def, "Ids", 0, false);
        parseProgram("/*a*/ a,a//asf \n, a ", def, "Ids", 0, false);
        parseProgram("/*a*/ a //asf \n\r a", def, "Ids", 0, true);
    }

    // test custom recursive whitespace in C style
    @Test
    public void test30() {
        String def = "module TEST \n" +
                "syntax #Layout ::= #Layout #LayoutItem \n" +
                "syntax #Layout ::= \"\" \n" +
                "syntax #LayoutItem ::= r\"/\\\\*([^\\\\*]|(\\\\*+([^\\\\*/])))*\\\\*+/\" \n" +
                "syntax #LayoutItem ::= r\"//[^\\n\\r]*\" \n" +
                "syntax #LayoutItem ::= r\"[\\\\ \\n\\r\\t]*\" \n" +
                "syntax #LayoutItem ::= r\"\\\\#[^\\n\\r]*\" \n" +
                "syntax #LayoutItem ::= r\"[\\\\ \\n\\r\\t]*\" \n" +
                "syntax #LayoutInner ::= #LayoutInner #LayoutItem2 \n" +
                "syntax #LayoutInner ::= \"\" \n" +
                "syntax #LayoutItem  ::= \"__attribute__\" r\"[\\\\ \\n\\r\\t]*\"  \"((\" #LayoutInner \"))\"\n" +
                "syntax #LayoutItem2 ::= r\"[^\\\\(\\\\)]*\"\n" +
                "syntax #LayoutItem2 ::= \"(\" #LayoutInner \")\" \n" +
                "syntax Ids ::= \"(\" Ids \")\"\n" +
                "syntax Ids ::= \"\"\n" +
                "endmodule\n";
        parseProgram("  __attribute__ (()) ", def, "Ids", 0, false);
        parseProgram("  ((__attribute__ ((asdf(a  ), ()))))", def, "Ids", 0, false);
        parseProgram("  ((__attribute__ ((()(())))))", def, "Ids", 0, false);
    }
}
