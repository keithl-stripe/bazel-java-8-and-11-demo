
load("defs.bzl", "my_java_binary_wrapper")

java_library(
    name = "lib", 
    srcs = ["Dep.java"], 
)

java_library(
    name = "lib2", 
    srcs = ["Dep2.java"], 
    deps = [":lib3"]
)

java_library(
    name = "lib3", 
    srcs = ["Dep3.java"], 
)

my_java_binary_wrapper(
    name = "bin8",  
    main_class = "com.stripe.keithtest.Src", 
    srcs = ["Src.java"], 
    deps = [
        ":lib", 
        ":lib2"
    ],
    version = "eight"
)

my_java_binary_wrapper(
    name = "bin11",  
    main_class = "com.stripe.keithtest.Src", 
    srcs = ["Src.java"], 
    deps = [
        ":lib", 
        ":lib2"
    ],
    version = "eleven"
)