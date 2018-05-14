package org.kframework.ctests;

import org.junit.Ignore;
import org.junit.Test;
import org.kframework.attributes.Source;
import org.kframework.definition.Definition;
import org.kframework.definition.Module;
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
import java.util.ArrayList;
import java.util.Set;

import static org.kframework.definition.Constructors.Sort;

public class OuterTests {

    private String startPath = "src/test/k/kore_in_k/tests";
    private String kastPath = "src/test/k/kore_in_k";
    private File definitionFile = new File(kastPath + "/outer.k");
    private String mainModule = "OUTER";
    private String mainSyntaxModule = "OUTER";
    private String startSymbol = "KDefinition";
    private ParserUtils defParser = new ParserUtils(FileUtil.testFileUtil()::resolveWorkingDirectory, new KExceptionManager(new GlobalOptions()));

    @Test @Ignore
    public void testOuter() {
        int total = 0, warnings = 0, ok = 0, error = 0, others = 0;
        Stopwatch sw = new Stopwatch(new GlobalOptions(true, GlobalOptions.Warnings.ALL, true));
        KExceptionManager kem = new KExceptionManager(new GlobalOptions());

        try {
            Definition baseK = defParser.loadDefinition(mainModule, mainSyntaxModule, FileUtil.load(definitionFile), new Source("OuterTests"), new ArrayList<>());
            Module syntaxModule = baseK.getModule(mainSyntaxModule).get();
            ParseInModule parser = RuleGrammarGenerator.getCombinedGrammar(RuleGrammarGenerator.getProgramsGrammar(syntaxModule, baseK));

            Object[] results = Files.find(Paths.get(startPath), Integer.MAX_VALUE,
                    (filePath, fileAttr) -> fileAttr.isRegularFile() && filePath.toString().endsWith(".k"))
                    .parallel()
                    .map(fp -> {
                        long startTime = System.currentTimeMillis();
                        //RunProcess.ProcessOutput po = RunProcess.execute(new HashMap<String, String>(), new File(kastPath), "kast.bat", fp.toString());
                        //String err = new String(po.stderr);
                        //System.out.println("[S]       " + fp.toString());
                        Tuple2<Either<Set<ParseFailedException>, Term>, Set<ParseFailedException>> rez =
                                parser.parseString(FileUtil.load(fp.toFile()), Sort(startSymbol), Source.apply(fp.toString()));
                        long totalTime = System.currentTimeMillis() - startTime;
                        if (rez._1().isLeft()) {
                            System.out.println("[Error]   " + fp.toString() + "   (" + totalTime + " ms)   " + rez._1.left().get().iterator().next().getKException().getLocation() + ":" + rez._1.left().get().iterator().next().getKException().getMessage());
                            return "[Error]";
                        } else if (rez._2().size() != 0) {
                            System.out.println("[Warning] " + fp.toString() + "   (" + totalTime + " ms)   " + rez._2.size());
                            return "[Warning]";
                        }
                        System.out.println("[ok]      " + fp.toString() + " (" + totalTime + " ms)   ");
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
}
