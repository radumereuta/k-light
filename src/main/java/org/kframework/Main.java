package org.kframework;

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

public class Main {

    private static ParserUtils defParser = new ParserUtils(
            FileUtil.testFileUtil()::resolveWorkingDirectory,
            new KExceptionManager(new GlobalOptions()));

    public static void main(String[] args){
        if (args.length < 1) {
            System.err.println("Usage: Main <file_to_process>");
        }
        process(new File(args[0]));
    }

    private static void process(File f) {
        String modName = f.getName().substring(0, f.getName().length() - 2).toUpperCase();
        ArrayList lookupDirs = new ArrayList();
        lookupDirs.add(f.getParentFile());
        Definition baseK = defParser.loadDefinition(modName, modName, FileUtil.load(f),
                                                    new Source(f.toString()), lookupDirs);
        String str = OuterToKORE.apply(baseK);
		System.out.println(str);
    }
}
