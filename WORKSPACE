load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "zulu_jdk8",
    build_file_content = """
java_runtime(
    name = "jdk",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)
""",
    sha256 = "466df2925ea76da17f0dfbf95176a37984c5b6b557d511e5d2e2c61782293f1e",
    strip_prefix = "zulu8.31.0.1-jdk8.0.181-macosx_x64",
    url = "https://cdn.azul.com/zulu/bin/zulu8.31.0.1-jdk8.0.181-macosx_x64.tar.gz",
)

# http_archive(
#     name = "zulu_jdk11",
#     build_file_content = """
# java_runtime(
#     name = "jdk",
#     srcs = glob(["**"]),
#     visibility = ["//visibility:public"],
# )
# """,
#     sha256 = "fa136c2c10c577adb14b83ec4e9662d771f375df563b8ebcb16e365ecb7229c8",
#     strip_prefix = "zulu11.43.21-ca-jdk11.0.9-macosx_x64",
#     url = "https://cdn.azul.com/zulu/bin/zulu11.43.21-ca-jdk11.0.9-macosx_x64.tar.gz",
# )