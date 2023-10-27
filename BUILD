# grab all of swift files in directory
# add to SwiftLint's build system
filegroup(
    name = "extra_rules",
    srcs = glob(["**/*.swift"]) + ["extra_rules.swift"],
    visibility = ["//visibility:public"],
)


# auto-register new rules to `extra_rules.swift`
genrule(
    name = "extra_rules_func",
    srcs = glob(["rules/*.swift"]),
    outs = ["extra_rules.swift"],
    cmd = """
set -euo pipefail
echo "public func extraRules() -> [Rule.Type] {" >> $(OUTS)
echo "  [" >> $(OUTS)
for file in $(SRCS); do
  filename=$$(basename -- "$$file")
  echo "    $${filename%.*}.self," >> $(OUTS)
done
echo "  ]" >> $(OUTS)
echo "}" >> $(OUTS)
    """,
)