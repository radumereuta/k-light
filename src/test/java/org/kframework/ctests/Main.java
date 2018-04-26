package org.kframework.ctests;

import com.beust.jcommander.internal.Lists;
import org.junit.Assert;
import org.junit.Ignore;
import org.junit.Test;
import org.kframework.attributes.Source;
import org.kframework.definition.Definition;
import org.kframework.definition.Module;
import org.kframework.kore.TreeNodesToKORE2;
import org.kframework.parser.concrete2kore.ParseInModule;
import org.kframework.parser.concrete2kore.ParserUtils;
import org.kframework.parser.concrete2kore.generator.RuleGrammarGenerator;
import org.kframework.treeNodes.Term;
import org.kframework.utils.FileUtil;
import org.kframework.utils.GlobalOptions;
import org.kframework.utils.Stopwatch;
import org.kframework.utils.errorsystem.KExceptionManager;
import org.kframework.utils.errorsystem.ParseFailedException;
import scala.Tuple2;
import scala.util.Either;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Set;

import static org.kframework.definition.Constructors.Sort;

public class Main {

    private static final String startPath = "src/test/k/unparametric_examples";
    private static ParserUtils defParser = new ParserUtils(FileUtil.testFileUtil()::resolveWorkingDirectory, new KExceptionManager(new GlobalOptions()));

    public static void main(String[] args) {
        int total = 0, warnings = 0, ok = 0, error = 0, others = 0;
        Stopwatch sw = new Stopwatch(new GlobalOptions(true, GlobalOptions.Warnings.ALL, true));
        KExceptionManager kem = new KExceptionManager(new GlobalOptions());

        try {
            Object[] results = Files.find(Paths.get(startPath), Integer.MAX_VALUE,
                    (filePath, fileAttr) -> fileAttr.isRegularFile() && filePath.toString().endsWith(".k"))
                    .parallel()
                    .map(fp -> {
                        long startTime = System.currentTimeMillis();
                        String rez = process(fp.toFile());
                        long totalTime = System.currentTimeMillis() - startTime;
                        if (rez.equals("[Error]")) {
                            System.out.println("[Error]   " + fp.toFile().getAbsolutePath() + "   (" + totalTime + " ms)");
                            return "[Error]";
                        } else if (rez.equals("[Warning]")) {
                            System.out.println("[Warning] " + fp.toFile().getAbsolutePath() + "   (" + totalTime + " ms)");
                            return "[Warning]";
                        }
                        System.out.println("[ok]      " + fp.toFile().getAbsolutePath() + " (" + totalTime + " ms)");
                        return "[ok]";
                    }).toArray();
            for (Object obj : results) {
                String str = (String) obj;
                switch (str) {
                    case "[ok]": ok++; break;
                    case "[Error]": error++; break;
                    case "[Warning]": warnings++; break;
                    case "[?????]": others++; break;
                }
            }
            System.out.println("Ok: " + ok);
            System.out.println("Error: " + error);
            System.out.println("Warning: " + warnings);
            System.out.println("Others: " + others);
            System.out.println("Total: " + (ok + error + warnings + others));
            sw.printTotal("Time: ");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static String process(File f) {
        Definition baseK = defParser.loadDefinition("TEST", "TEST", FileUtil.load(f), new Source(f.toString()), Lists.newArrayList());
        Module syntaxModule = baseK.getModule("TEST").get();
        ParseInModule parser = RuleGrammarGenerator.getCombinedGrammar(RuleGrammarGenerator.getProgramsGrammar(syntaxModule, baseK));

        // TODO: make a transformer from kore to new kore, and parse bubbles to new kore
        File inputFile = new File("c:/work/test/a.test");
        Tuple2<Either<Set<ParseFailedException>, Term>, Set<ParseFailedException>> rez1 =
                parser.parseStringKeepAmb(FileUtil.load(inputFile), Sort("Start"), Source.apply(inputFile.toString()));

        System.out.println(rez1.toString());

        System.out.println("kore: " + TreeNodesToKORE2.apply(rez1._1.right().get()));
        return "[ok]";
    }

    @Test @Ignore
    public void testTestDotK() {
        System.out.println(new File(".").getAbsolutePath());
        Definition baseK = defParser.loadDefinition("TEST", "TEST", FileUtil.load(new File("c:/work/test/test.k")), new Source("CTests"), Lists.newArrayList());
        Module syntaxModule = baseK.getModule("TEST").get();
        ParseInModule parser = RuleGrammarGenerator.getCombinedGrammar(RuleGrammarGenerator.getProgramsGrammar(syntaxModule, baseK));

        File inputFile = new File("c:/work/test/a.test");
        Tuple2<Either<Set<ParseFailedException>, Term>, Set<ParseFailedException>> rez1 =
                parser.parseString(FileUtil.load(inputFile), Sort("Start"), Source.apply(inputFile.toString()));

        System.out.println(rez1.toString());

        Assert.assertTrue(rez1._1.isRight());

        System.out.println("kore: " + TreeNodesToKORE2.apply(rez1._1.right().get()));
    }
}
