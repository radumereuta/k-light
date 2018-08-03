package org.kframework.ctests;

import org.junit.Test;
import org.kframework.attributes.Source;
import org.kframework.definition.Definition;
import org.kframework.kore.OuterToKORE;
import org.kframework.parser.concrete2kore.ParserUtils;
import org.kframework.utils.FileUtil;
import org.kframework.utils.GlobalOptions;
import org.kframework.utils.Stopwatch;
import org.kframework.utils.RunProcess;
import org.kframework.utils.errorsystem.KExceptionManager;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;

public class MainTest {

    private static final String startPath = "src/test/k/unparametric_examples";
    private static ParserUtils defParser = new ParserUtils(FileUtil.testFileUtil()::resolveWorkingDirectory, new KExceptionManager(new GlobalOptions()));

    @Test
    public void testMain() {
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

    private static String process(File f) {
        String modName = f.getName().substring(0, f.getName().length() - 2).toUpperCase();
        ArrayList lookupDirs = new ArrayList();
        lookupDirs.add(f.getParentFile());
        Definition baseK = defParser.loadDefinition(modName, modName, FileUtil.load(f), new Source(f.toString()), lookupDirs);

        String str = OuterToKORE.apply(baseK);
        String termination = "ore.info";
        FileUtil.save(new File(f.getAbsolutePath() + termination), str);
        try {
            RunProcess.ProcessOutput po = RunProcess.execute(new HashMap<>(), new File(startPath), "kore-parser", "--no-print-definition", f.getAbsolutePath() + termination);
            return po.exitCode != 0 ? "[Error]" : "[ok]";
        } catch (InterruptedException | IOException e) {
            e.printStackTrace();
            return "[Error]";
        }
    }
}
