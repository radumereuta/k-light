package org.kframework.kast;

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
import java.util.ArrayList;
import java.util.Set;

import static org.kframework.definition.Constructors.Sort;


public class Main {

    private static ParserUtils defParser = new ParserUtils(
            FileUtil.testFileUtil()::resolveWorkingDirectory,
            new KExceptionManager(new GlobalOptions()));

    public static void main(String[] args){
        if (args.length != 3) {
            System.err.println("Usage: <grammar.k> <start-symbol> <file-to-parse>");
            return;
        }
        File grammarFile = new File(args[0]);
        String startSymbol = args[1];
        File inputFile = new File(args[2]);
        String modName = grammarFile.getName().substring(0, grammarFile.getName().length() - 2).toUpperCase();
        ArrayList lookupDirs = new ArrayList();
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
        } else {
            System.out.println(TreeNodesToK5AST.apply(rez._1.right().get()));
        }
    }
}
