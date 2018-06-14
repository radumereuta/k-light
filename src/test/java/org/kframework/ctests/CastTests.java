package org.kframework.ctests;

import org.junit.Ignore;
import org.junit.Test;
import org.kframework.attributes.Source;
import org.kframework.definition.Bubble;
import org.kframework.definition.Definition;
import org.kframework.definition.Module;
import org.kframework.definition.Sentence;
import org.kframework.frontend.Sort;
import org.kframework.parser.concrete2kore.ParseInModule;
import org.kframework.parser.concrete2kore.ParserUtils;
import org.kframework.parser.concrete2kore.generator.RuleGrammarGenerator;
import org.kframework.utils.FileUtil;
import org.kframework.utils.GlobalOptions;
import org.kframework.utils.Stopwatch;
import org.kframework.utils.errorsystem.KExceptionManager;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;

import static org.kframework.definition.Constructors.Sort;
import static org.kframework.utils.Collections.mutable;


public class CastTests {

    private static final String startPath = "src/test/k/performance";
    private static ParserUtils defParser = new ParserUtils(FileUtil.testFileUtil()::resolveWorkingDirectory, new KExceptionManager(new GlobalOptions()));

    @Test
    public void testCasts() {
        int total = 0, warnings = 0, ok = 0, error = 0, others = 0;
        Stopwatch sw = new Stopwatch(new GlobalOptions(true, GlobalOptions.Warnings.ALL, true));
        KExceptionManager kem = new KExceptionManager(new GlobalOptions());

        try {
            Object[] results = Files.find(Paths.get(startPath), Integer.MAX_VALUE,
                    (filePath, fileAttr) -> fileAttr.isRegularFile() && filePath.toString().endsWith(".k"))
                    //.parallel()
                    .map(fp -> {
                        long startTime = System.currentTimeMillis();
                        process(fp.toFile());
                        long totalTime = System.currentTimeMillis() - startTime;
                        return "[ok]";
                    }).toArray();
            sw.printTotal("Time: ");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void process(File f) {
        String modName = f.getName().substring(0, f.getName().length() - 2).toUpperCase();
        ArrayList lookupDirs = new ArrayList();
        lookupDirs.add(f.getParentFile());
        Definition baseK = defParser.loadDefinition(modName, modName, FileUtil.load(f), new Source(f.toString()), lookupDirs);

        StringBuilder times = new StringBuilder();
        long startTime = System.currentTimeMillis();
        long intermediateTime;
        long cumulativeTime = 0;
        long ruleCount = 0;

        for (Module m : mutable(baseK.modules())) {
            ParseInModule parser = null;
            for (Sentence s : mutable(m.localSentences())) {
                if (s instanceof Bubble) {
                    Bubble b = (Bubble) s;
                    if (parser == null)
                        parser = RuleGrammarGenerator.getCombinedGrammar(RuleGrammarGenerator.getProgramsGrammar(m, baseK));
                    intermediateTime = System.currentTimeMillis();
                    int startLine = Integer.parseInt(b.att().get("contentStartLine").get().get());
                    int startColumn = Integer.parseInt(b.att().get("contentStartColumn").get().get());
                    Sort sort = Sort(b.att().get("start").isDefined() ?
                            b.att().get("start").get().get() : "K");
                    parser.parseStringTerm(
                            b.contents().trim(),
                            sort,
                            b.source(),
                            startLine,
                            startColumn,
                            true);
                    long parseTime = System.currentTimeMillis() - intermediateTime;
                    cumulativeTime += parseTime;
                    ruleCount++;
                    times.append(startLine).append(":").append(startColumn).append(" ")
                            .append(sort.localName()).append(" - ")
                            .append(parseTime).append("ms\n");
                }
            }
        }
        startTime = System.currentTimeMillis() - startTime;
        times.append("Total: ").append(startTime).append(" ms\nAverage: ").append(cumulativeTime/ruleCount).append(" ms\n");
        FileUtil.save(new File(f.getAbsolutePath() + ".times"), times.toString());
        System.out.println(f.getAbsolutePath() + " - " + startTime + " ms Avg: " + (cumulativeTime/ruleCount));
    }

    @Test @Ignore
    public void testGenSorts() {
        int count = 1000;
        for (int i = 0; i < count; i++)
            System.out.println("  syntax S" + i);
        for (int i = 0; i < count; i++) {
            System.out.println("  syntax K  ::= S" + i + " [symbol(inj)]");
            System.out.println("  syntax S" + i + " ::= KBott [symbol(inj)]");
        }
    }

    @Test @Ignore
    public void testGenPostfixCasts() {
        int count = 1000;
        for (int i = 0; i < count; i++) {
            System.out.println("  syntax S" + i + " ::= S" + i + "  \":S" + i + "\" [symbol(semanticCastToS" + i + ")]");
            System.out.println("  syntax S" + i + " ::= S" + i + " \"::S" + i + "\" [symbol(syntacticCastToS" + i + ")]");
            System.out.println("  syntax S" + i + " ::= K \":>S" + i + "\" [symbol(outerCastToS" + i + ")]");
            System.out.println("  syntax KBott ::= S" + i + " \"<:S" + i + "\" [symbol(innerCastToS" + i + ")]");
        }
    }

    @Test @Ignore
    public void testGenGuardedPostfixCasts() {
        int count = 1000;
        for (int i = 0; i < count; i++) {
            System.out.println("  syntax S" + i + " ::= \"{\" S" + i + "  \"}:S" + i + "\" [symbol(semanticCastToS" + i + ")]");
            System.out.println("  syntax S" + i + " ::= \"{\" S" + i + " \"}::S" + i + "\" [symbol(syntacticCastToS" + i + ")]");
            System.out.println("  syntax S" + i + " ::= \"{\" K \"}:>S" + i + "\" [symbol(outerCastToS" + i + ")]");
            System.out.println("  syntax KBott ::= \"{\" S" + i + " \"}<:S" + i + "\" [symbol(innerCastToS" + i + ")]");
        }
    }

    @Test @Ignore
    public void testGenPrefixCasts() {
        int count = 1000;
        for (int i = 0; i < count; i++) {
            System.out.println("  syntax S" + i + " ::= \"S" + i + ":(\" S" + i + " \")\" [symbol(semanticCastToS" + i + ")]");
            System.out.println("  syntax S" + i + " ::= \"S" + i + "::(\" S" + i + " \")\" [symbol(syntacticCastToS" + i + ")]");
            System.out.println("  syntax S" + i + " ::= \"S" + i + "<:(\" K \")\" [symbol(outerCastToS" + i + ")]");
            System.out.println("  syntax KBott ::= \"S" + i + ":>(\" S" + i + " \")\" [symbol(innerCastToS" + i + ")]");
        }
    }
}
