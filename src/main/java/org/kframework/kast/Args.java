package org.kframework.kast;

import com.beust.jcommander.IParameterValidator;
import com.beust.jcommander.Parameter;
import com.beust.jcommander.ParameterException;

import java.util.ArrayList;
import java.util.List;

public class Args {
    @Parameter(description = "<grammar.k> <start-symbol> <file-to-parse>", arity = 3)
    public List<String> parameters = new ArrayList<>();

    @Parameter(names={"--help", "-h"}, description="Print this help message", help = true)
    public boolean help = false;

    @Parameter(names="-I", description="Add a directory to the search path for requires statements.", variableArity = true)
    public List<String> includes = new ArrayList<>();

    @Parameter(names={"--module"}, description="Parse text in specified module.")
    public String modName;

    @Parameter(names={"--output"}, description="Print the AST in [kast|meta-kast|kore|info-kore|meta-kore] format.", validateWith = OutputValidator.class)
    public String output = Output.kast;

    public static class OutputValidator implements IParameterValidator {
        public void validate(String name, String value) throws ParameterException {
            assert name.equals("--output");
            if (value.equals(Output.kast) ||
                    value.equals(Output.metaKast) ||
                    value.equals(Output.kore) ||
                    value.equals(Output.infoKore) ||
                    value.equals(Output.metaKore))
                return;
            throw new ParameterException("Parameter " + name + " accepts one of [kast|meta-kast|kore|info-kore|meta-kore], found: " + value);
        }
    }

    public static class Output {
        public static final String kast = "kast";
        public static final String metaKast = "meta-kast";
        public static final String kore = "kore";
        public static final String infoKore = "info-kore";
        public static final String metaKore = "meta-kore";
    }
}
