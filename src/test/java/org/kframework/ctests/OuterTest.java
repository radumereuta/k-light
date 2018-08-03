package org.kframework.ctests;

import org.junit.Test;
import org.kframework.attributes.Source;
import org.kframework.definition.Definition;
import org.kframework.definition.Module;
import org.kframework.kore.TreeNodesToOuterKORE;
import org.kframework.parser.concrete2kore.ParseInModule;
import org.kframework.parser.concrete2kore.ParserUtils;
import org.kframework.parser.concrete2kore.generator.RuleGrammarGenerator;
import org.kframework.treeNodes.Term;
import org.kframework.utils.FileUtil;
import org.kframework.utils.GlobalOptions;
import org.kframework.utils.RunProcess;
import org.kframework.utils.Stopwatch;
import org.kframework.utils.errorsystem.KExceptionManager;
import org.kframework.utils.errorsystem.ParseFailedException;
import scala.Tuple2;
import scala.util.Either;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

import static org.kframework.definition.Constructors.Sort;

public class OuterTest {

    private String startPath = "src/test/k/kore_in_k/tests";
    private String kastPath = "src/test/k/kore_in_k";
    private File definitionFile = new File(kastPath + "/outer.k");
    private String mainModule = "OUTER";
    private String mainSyntaxModule = "OUTER";
    private String startSymbol = "KDefinition";
    private ParserUtils defParser = new ParserUtils(FileUtil.testFileUtil()::resolveWorkingDirectory, new KExceptionManager(new GlobalOptions()));
    Definition baseK =
            defParser.loadDefinition(
                    mainModule,
                    mainSyntaxModule,
                    FileUtil.load(definitionFile),
                    new Source(definitionFile.getAbsolutePath()),
                    Arrays.asList(new File(kastPath)));
    Module syntaxModule = baseK.getModule(mainSyntaxModule).get();
    ParseInModule parser = RuleGrammarGenerator.getCombinedGrammar(RuleGrammarGenerator.getProgramsGrammar(syntaxModule, baseK));

    @Test
    public void testOuter() {
        int warnings = 0, ok = 0, error = 0;
        Stopwatch sw = new Stopwatch(new GlobalOptions(true, GlobalOptions.Warnings.ALL, true));

        try {
            Object[] results = Files.find(Paths.get(startPath), Integer.MAX_VALUE,
                    (filePath, fileAttr) -> fileAttr.isRegularFile() && filePath.toString().endsWith(".k"))
                    .parallel()
                    .map(fp -> {
                        String rez = process(fp.toFile());
                        return rez;
                    }).toArray();
            for (Object obj : results) {
                String str = (String) obj;
                switch (str) {
                    case "[ok]": ok++; break;
                    case "[Warning]": warnings++; break;
                    default: error++;
                }
            }
            System.out.println("Ok: " + ok);
            System.out.println("Error: " + error);
            System.out.println("Warning: " + warnings);
            System.out.println("Total: " + (ok + error + warnings));
            sw.printTotal("Time: ");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private String process(File f) {
        long startTime = System.currentTimeMillis();
        Tuple2<Either<Set<ParseFailedException>, Term>, Set<ParseFailedException>> rez =
                parser.parseString(FileUtil.load(f), Sort(startSymbol), Source.apply(f.toString()));
        long totalTime = System.currentTimeMillis() - startTime;

        if (rez._1.isLeft()) {
            System.out.println("[Error]   " + f.getAbsolutePath() + "   (" + totalTime + " ms)\n" + rez._1.left().get().iterator().next().toString());
            return "[Error]";
        } else if (!rez._2.isEmpty()) {
            System.out.println("[Warning] " + f.getAbsolutePath() + "   (" + totalTime + " ms)");
            return "[Warning]";
        }
        String str = TreeNodesToOuterKORE.apply(rez._1.right().get());
        String termination = "ore";
        FileUtil.save(new File(f.getAbsolutePath() + termination), str);
        try {
            RunProcess.ProcessOutput po = RunProcess.execute(new HashMap<>(), new File(startPath), "kore-parser", f.getAbsolutePath() + termination);
            if (po.exitCode != 0)
                System.out.println("[KoreErr] " + f.getAbsolutePath() + "   (" + totalTime + " ms)");
            else
                System.out.println("[Ok]      " + f.getAbsolutePath() + "   (" + totalTime + " ms)");
            return po.exitCode != 0 ? "[KoreErr]" : "[ok]";
        } catch (InterruptedException | IOException e) {
            e.printStackTrace();
            return "[IOError]";
        }
    }

}
