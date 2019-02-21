package org.kframework.kast;

import com.beust.jcommander.Parameter;

import java.util.ArrayList;
import java.util.List;

public class Args {
    @Parameter(arity = 3)
    public List<String> parameters = new ArrayList<>();

    @Parameter(names={"--help", "-h"}, description="Print this help message", help = true)
    public boolean help = false;

    @Parameter(names="-I", description="Add a directory to the search path for requires statements.", variableArity = true)
    public List<String> includes = new ArrayList<>();

    @Parameter(names={"--meta"}, description="Print terms at the meta-level.")
    public boolean meta = false;
}
