package org.kframework.kast;

import com.beust.jcommander.JCommander;
import org.kframework.attributes.Source;
import org.kframework.definition.Definition;
import org.kframework.parser.concrete2kore.ParseInModule;
import org.kframework.parser.concrete2kore.ParserUtils;
import org.kframework.parser.concrete2kore.generator.RuleGrammarGenerator;
import org.kframework.treeNodes.Term;
import org.kframework.utils.FileUtil;
import org.kframework.utils.GlobalOptions;
import org.kframework.utils.errorsystem.KExceptionManager;
import org.kframework.utils.errorsystem.ParseFailedException;
import scala.Tuple2;
import scala.util.Either;

import java.io.File;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static org.kframework.definition.Constructors.Sort;


public class Main {

    private static ParserUtils defParser = new ParserUtils(
            FileUtil.testFileUtil()::resolveWorkingDirectory,
            new KExceptionManager(new GlobalOptions()));

    public static void main(String[] args) {
        Args jargs = new Args();
        JCommander jc = JCommander.newBuilder().addObject(jargs).build();
        jc.setProgramName("k-light2k5");
        jc.parse(args);

        if (jargs.help) {
            jc.usage();
        } else {
            File grammarFile = new File(jargs.parameters.get(0));
            String startSymbol = jargs.parameters.get(1);
            File inputFile = new File(jargs.parameters.get(2));
            String modName = jargs.modName;
            if (modName == null) modName = grammarFile.getName().substring(0, grammarFile.getName().length() - 2).toUpperCase();

            List<File> lookupDirs = jargs.includes.stream()
                    .map(FileUtil.testFileUtil()::resolveWorkingDirectory).collect(Collectors.toList());
            lookupDirs.add(grammarFile.getParentFile());
            Definition baseK = defParser.loadDefinition(modName, modName, FileUtil.load(grammarFile),
                    new Source(grammarFile.toString()), lookupDirs);

            ParseInModule parser = RuleGrammarGenerator.getCombinedGrammar(baseK.getModule(modName).get());
            Tuple2<Either<Set<ParseFailedException>, Term>, Set<ParseFailedException>> rez =
                    parser.parseStringKeepAmb(
                            FileUtil.load(inputFile),
                            Sort(startSymbol),
                            Source.apply(inputFile.getAbsolutePath()));
            if (rez._1.isLeft()) {
                for (ParseFailedException pfe : rez._1.left().get()) {
                    System.err.println(pfe.getKException().toString());
                }
                System.exit(2);
            } else {
                if (jargs.meta)
                    System.out.println(TreeNodesToK5MetaAST.apply(rez._1.right().get()));
                else
                    System.out.println(TreeNodesToK5AST.apply(rez._1.right().get()));
            }
        }
        System.exit(0);
    }
}
