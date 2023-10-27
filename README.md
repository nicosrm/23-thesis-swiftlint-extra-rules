# SwiftLines Extra Rules

This is the submodule for extra SwiftLint rules to validate the conformance of SwiftUI components and applications with selected [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/) from Apple.


## Extra Rules

| identifier                          | opt-in | description                             |
|-------------------------------------|--------|-----------------------------------------|
| `button_background_notifier`        | yes    | button backgrounds                      |
| `button_shape_hstack_outer`         | no     | horizontally stacked button style       |
| `button_shape_single_warning`       | yes    | single button style                     |
| `button_shape_vstack_outer`         | no     | vertically stacked button style         |
| `feedback_sound`                    | no     | feedback sound for clickable components |
| `focus_shape`                       | no     | focus shape for clickable components    |
| `navigation_bar_title_size_warning` | yes    | size of navigation bar title            |
| `navigation_title_length`           | no     | short navigation titles                 |
| `ornament_borderless_button`        | no     | ornament button style                   |
| `ornament_system_warning`           | yes    | system-provided ornaments               |
| `ornament_visibility`               | no     | visible ornaments                       |
| `ornament_width_warning`            | yes    | ornament not wider than window          |
| `sidebar_initially_visible`         | no     | initially visible sidebars              |
| `tab_item_non_empty_label`          | no     | labeled tab items                       |
| `toggle_button_style`               | no     | toggle-style reserved button style      |
| `too_many_tabs`                     | no     | max. 8 tabs in tab bar, use sidebar     |


## Usage

- install [Bazel](https://bazel.build/install)
- clone this repository / add as submodule

```shell
git submodule add https://github.com/nicosrm/23-thesis-swiftlint-rules.git swiftlint_extra_rules
```

- create files as shown below


## Create files

Add the following files to the root directory of the project that is to be linted:

### `.bazelrc`

```
common --enable_bzlmod
```

### `WORKSPACE`

```python
workspace(name = "<WORKSPACE_NAME>")
```

### `MODULE.bazel`

```python
module(
    name = "<MODULE_NAME>",
    version = "0.0.0",
    compatibility_level = 1,
    repo_name = "<MODULE_NAME>",
)

bazel_dep(name = "swiftlint", version = "0.52.2", repo_name = "SwiftLint")

extra_rules = use_extension("@SwiftLint//bazel:extensions.bzl", "extra_rules")
extra_rules.setup(srcs = "@<MODULE_NAME>//swiftlint_extra_rules:extra_rules")

bazel_dep(name = "rules_xcodeproj", version = "1.5.1")
```

### `BUILD`

```python
load("@rules_xcodeproj//xcodeproj:defs.bzl", "xcodeproj")

xcodeproj(
    name = "swiftlint_xcodeproj",
    project_name = "SwiftLint",
    tags = ["manual"],
    top_level_targets = [
        "@SwiftLint//:swiftlint",
        "@SwiftLint//Tests:ExtraRulesTests",
    ],
)
```

### `.gitignore`
 
Add the following to your `.gitignore`:

```shell
# Bazel & SwiftLint
bazel-*
SwiftLint.xcodeproj
```


## Build and run SwiftLint

```shell
bazel build -c opt @SwiftLint//:swiftlint
bazel run -c opt @SwiftLint//:swiftlint
```


## Add Xcode integration

```shell
# build SwiftLint.xcodeproj project
bazel run swiftlint_xcodeproj

# open project in Xcode
xed SwiftLint.xcodeproj
```


## Add configuration file

Optionally add a configuration file for SwiftLint, see SwiftLint's [documentation](https://github.com/realm/SwiftLint/blob/main/README.md#configuration)
