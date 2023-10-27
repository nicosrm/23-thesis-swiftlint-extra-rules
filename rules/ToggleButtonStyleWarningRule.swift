//
//  ToggleButtonStyleWarningRule.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore
import SourceKittenFramework

/// Rule that produces violation if button has system's toggle style,
/// i.e. black text on white background.
struct ToggleButtonStyleWarningRule: ASTRule, ConfigurationProviderRule {

    var configuration = SeverityConfiguration(.warning)

    static var description: RuleDescription {

        RuleDescription(
            identifier: "toggle_button_style",
            name: "Toggle Button Style Warning",
            description: "Only use the system's toggle button style " +
                "(white background with black foreground color) for " +
                "components with toggle functionality",
            kind: .style,
            nonTriggeringExamples: Self.nonTriggeringExamples,
            triggeringExamples: Self.triggeringExamples
        )
    }

    func validate(
        file: SwiftLintFile,
        kind: SwiftDeclarationKind,
        dictionary: SourceKittenDictionary
    ) -> [StyleViolation] {

        // only check View structs
        guard kind == .struct,
              dictionary.inheritedTypes.contains("View"),
              dictionary.substructure.isNotEmpty else {
            return []
        }

        return self.findViolations(
            file: file,
            substructure: dictionary.substructure
        )
    }
}

// MARK: - Private functions

private extension ToggleButtonStyleWarningRule {

    /// Recursively check file for feedback sound violations.
    ///
    /// - Returns: All violations
    func findViolations(
        file: SwiftLintFile,
        substructure: [SourceKittenDictionary]
    ) -> [StyleViolation] {

        var violations = [StyleViolation]()

        for dictionary in substructure {

            guard let offset: ByteCount = dictionary.offset else {
                continue
            }

            if dictionary.hasBlackForeground(in: file) &&
               dictionary.hasWhiteBackground(in: file) {
                violations.append(
                    StyleViolation(
                        ruleDescription: Self.description,
                        severity: self.configuration.severity,
                        location: Location(file: file, byteOffset: offset)
                    )
                )
            } else if dictionary.substructure.isNotEmpty {
                // recursively check substructures
                violations.append(
                    contentsOf: self.findViolations(
                        file: file,
                        substructure: dictionary.substructure
                    )
                )
            }
        }

        return violations
    }
}


// MARK: - SourceKittenDictionary extension

private extension SourceKittenDictionary {

    /// Determine whether dictionary has black `forgroundColor` modifier.
    func hasBlackForeground(in file: SwiftLintFile) -> Bool {

        self.hasModifier(
            anyOf: [
                SwiftUIModifier(
                    name: "foregroundColor",
                    arguments: [
                        .init(
                            name: "",
                            values: [
                                ".black",
                                "Color.black"
                            ]
                        )
                    ]
                )
            ],
            in: file
        )
    }

    /// Determine whether dictionary has white background modifier.
    func hasWhiteBackground(in file: SwiftLintFile) -> Bool {

        let colorOptions: [String] = [
            "Color.white",
            ".white",
            "HierarchicalShapeStyle.primary",
            ".primary"
        ]

        // determine whether dictionary has modifier with white color
        // as an argument
        let hasModifierWithWhiteColorArgument = self.hasModifier(
            anyOf: [
                SwiftUIModifier(
                    name: "background",
                    arguments: [
                        .init(
                            name: "",
                            values: colorOptions
                        ),
                        .init(
                            name: "ignoresSafeAreaEdges",
                            required: false,
                            values: []
                        )
                    ]
                ),
                SwiftUIModifier(
                    name: "background",
                    arguments: [
                        .init(
                            name: "",
                            values: colorOptions,
                            matchType: .prefix
                        ),
                        .init(
                            name: "in",
                            values: []
                        ),
                        .init(
                            name: "fillStyle",
                            required: false,
                            values: []
                        )
                    ]
                ),
                SwiftUIModifier(
                    name: "tint",
                    arguments: [
                        .init(
                            name: "",
                            values: colorOptions
                        )
                    ]
                )
            ],
            in: file
        )

        if hasModifierWithWhiteColorArgument {
            return true
        }

        // look for missing background case
        // e.g. `.background(alignment:content:)`

        let backgroundNameOptions = [
            ".background\n",
            ".background"
        ]

        guard let name = self.name else {
            return false
        }

        var containsBackgroundNameOption = false
        for nameOption in backgroundNameOptions {
            if name.contains(nameOption) {
                containsBackgroundNameOption = true
                break
            }
        }

        guard containsBackgroundNameOption else {
            return false
        }

        guard let argumentValue = self.getSingleUnnamedArgumentValue(in: file) else {
            return false
        }

        for colorOption in colorOptions {
            if argumentValue.contains(colorOption) {
                return true
            }
        }

        return false
    }
}
