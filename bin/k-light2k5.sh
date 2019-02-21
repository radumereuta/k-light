#!/bin/sh

script_dir=$(dirname "$0")
target_dir="$script_dir/../target"
mvn_dir="$HOME/.m2/repository"

classpath="$mvn_dir/commons-io/commons-io/2.4/commons-io-2.4.jar":\
"$mvn_dir/org/scala-lang/scala-library/2.12.4/scala-library-2.12.4.jar":\
"$mvn_dir/com/google/collections/google-collections/1.0/google-collections-1.0.jar":\
"$mvn_dir/dk/brics/automaton/automaton/1.11-8/automaton-1.11-8.jar":\
"$mvn_dir/com/beust/jcommander/1.72/jcommander-1.72.jar":\
"$mvn_dir/org/apache/commons/commons-lang3/3.3.2/commons-lang3-3.3.2.jar":\
"$mvn_dir/org/pcollections/pcollections/2.1.2/pcollections-2.1.2.jar":\
"$target_dir/k-light-1.0-SNAPSHOT.jar"


java -cp "$classpath" org.kframework.kast.Main "$@"
