
def _platforms_transition_impl(settings, attr):
    # settings provides read access to existing flags. But
    # this transition doesn't need to read any flags.
    return {
        "eight": {"//command_line_option:javacopt": ["--release=8"]},
        "eleven": {"//command_line_option:javacopt": ["--release=11"]},
    }

# This defines a Starlark transition and which flags it reads and
# writes. In this case we don't need to read any flags - we
# universally set --/custom_settings:mycopts according to whatever
# is set in the owning rule's "set_features" attribute.
_platforms_transition = transition(
    implementation = _platforms_transition_impl,
    inputs = [],
    outputs = ["//command_line_option:javacopt"],
)

def _my_java_library_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.write(
        output = out,
        content = "Hello\n",
    )
    print("VALUE: ")
    print(ctx.split_attr.deps)
    d = ctx.split_attr.deps[ctx.attr.version]
    print(d)
    return [java_common.merge([dep[JavaInfo] for dep in d])]

my_java_binary = rule(
    implementation = _my_java_library_impl,
    attrs = {
        "deps": attr.label_list(cfg = _platforms_transition),
        "version": attr.string(default = "eleven"),
        "_out": attr.output(),
        # This is a stock Bazel requirement for any rule that uses Starlark transitions.
        "_whitelist_function_transition": attr.label(
            default = "@bazel_tools//tools/whitelists/function_transition_whitelist",
        ),
    }
)

def my_java_binary_wrapper(name, version = None, deps = [], **args):
    lib_name = name + '_wrapped'
    my_java_binary(name = lib_name, version = version, deps = deps)
    if version == "eight":
        args["$jvm"] = "@zulu_jdk8//:jdk"
    
    native.java_binary(name = name, deps = [":" + lib_name], **args)
