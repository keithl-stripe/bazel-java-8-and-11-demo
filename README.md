# Java 8 and Java 11 in the same Bazel build via Transitions
POC to show how Bazel's transitions feature allows you to build Java code using multiple versions of Java in the same repo

## Proof that it works
```
% bazel build -k //src:bin8_deploy.jar //src:bin11_deploy.jar
DEBUG: /Users/keithl/java-transition-test/src/defs.bzl:26:10: VALUE: 
DEBUG: /Users/keithl/java-transition-test/src/defs.bzl:27:10: {"eight": [<target //src:lib>, <target //src:lib2>], "eleven": [<target //src:lib>, <target //src:lib2>]}
DEBUG: /Users/keithl/java-transition-test/src/defs.bzl:29:10: [<target //src:lib>, <target //src:lib2>]
DEBUG: /Users/keithl/java-transition-test/src/defs.bzl:26:10: VALUE: 
DEBUG: /Users/keithl/java-transition-test/src/defs.bzl:27:10: {"eight": [<target //src:lib>, <target //src:lib2>], "eleven": [<target //src:lib>, <target //src:lib2>]}
DEBUG: /Users/keithl/java-transition-test/src/defs.bzl:29:10: [<target //src:lib>, <target //src:lib2>]
INFO: Analyzed 2 targets (0 packages loaded, 0 targets configured).
INFO: Found 2 targets...
INFO: Elapsed time: 0.807s, Critical Path: 0.64s
INFO: 7 processes: 1 internal, 4 darwin-sandbox, 2 worker.
INFO: Build completed successfully, 7 total actions

% javap -verbose -cp bazel-bin/src/bin8_deploy.jar com.stripe.keithtest.Dep3 | grep version 
  minor version: 0  
  major version: 52

% javap -verbose -cp bazel-bin/src/bin11_deploy.jar com.stripe.keithtest.Dep3 | grep version
  minor version: 0
  major version: 55
  
% for i in 8 11; do echo -n "$i: "; bazel-bin/src/bin$i --print_javabin; echo; done
8: /Users/keithl/java-transition-test/bazel-bin/src/bin8.runfiles/zulu_jdk8/bin/java
11: /Users/keithl/java-transition-test/bazel-bin/src/bin11.runfiles/local_jdk/bin/java

% /Users/keithl/java-transition-test/bazel-bin/src/bin8.runfiles/zulu_jdk8/bin/java -version
openjdk version "1.8.0_181"
OpenJDK Runtime Environment (Zulu 8.31.0.1-macosx) (build 1.8.0_181-b02)
OpenJDK 64-Bit Server VM (Zulu 8.31.0.1-macosx) (build 25.181-b02, mixed mode)

% /Users/keithl/java-transition-test/bazel-bin/src/bin11.runfiles/local_jdk/bin/java -version
openjdk version "11.0.11" 2021-04-20 LTS
OpenJDK Runtime Environment Corretto-11.0.11.9.1 (build 11.0.11+9-LTS)
OpenJDK 64-Bit Server VM Corretto-11.0.11.9.1 (build 11.0.11+9-LTS, mixed mode)
```

## Notes about `bazel-bin`

Bazel only creates one `bazel-bin` symlink, which usually points to the JDK11 output dir. To access outputs of JDK8 
targets (without `bazel run`) you'll need to find the `bazel-out` directory corresponding to JDK8. At Stripe we solve 
this by creating a `bazel-bin-jdk8` symlink. We use a Bazel aspect to write a JSON file, and a small Bazel wrapper 
script (in `tools/bazel`) to parse those and create/update the `bazel-bin-jdk8` symlink. Please reach out if you'd like 
some sample code for this.