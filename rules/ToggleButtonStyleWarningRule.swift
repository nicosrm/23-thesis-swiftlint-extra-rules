//
//  ToggleButtonStyleWarningRule.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore
import SourceKittenFramework

/// Rule that produces violation if button has system's toggle style,
/// i.e. black text on white background. Also, produces violation if
/// `foregroundColor` and `backgroundColor` modifiers are passed a variable.
struct ToggleButtonStyleWarningRule: ASTRule, ConfigurationProviderRule {

    var configuration = SeverityConfiguration(.warning)

    static var description: RuleDescription {

        RuleDescription(
            identifier: "toggle_button_style",
            name: "Toggle Button Style Warning",
            description: "Make sure to use the system's toggle button style " +
                "(white background with black foreground color) for " +
                "components with toggle functionality only",
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

            // check violations
            if dictionary.hasBlackForeground(in: file) &&
                (dictionary.hasWhiteBackground(in: file) ||
                 dictionary.hasVariableBackgroundModifier(in: file)) {
                violations.append(
                    StyleViolation(
                        ruleDescription: Self.description,
                        severity: self.configuration.severity,
                        location: Location(file: file, byteOffset: offset)
                    )
                )
            } else if dictionary.hasWhiteBackground(in: file) &&
                        (dictionary.hasBlackForeground(in: file) ||
                         dictionary.hasVariableForeground(in: file)) {
                violations.append(
                    StyleViolation(
                        ruleDescription: Self.description,
                        severity: self.configuration.severity,
                        location: Location(file: file, byteOffset: offset)
                    )
                )
            } else if dictionary.hasVariableBackgroundModifier(in: file) &&
                        dictionary.hasVariableForeground(in: file) {
                violations.append(
                    StyleViolation(
                        ruleDescription: Self.description,
                        severity: self.configuration.severity,
                        location: Location(file: file, byteOffset: offset)
                    )
                )
            // no violations, check substructure
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

// MARK: - SourceKittenDictionary extension foreground

private extension SourceKittenDictionary {

    /// Determine wether dictionary has `foregroundColor`, no matter which value is passed.
    func hasForegroundColor(
        with colorOptions: [String] = [],
        in file: SwiftLintFile,
        matchType: SwiftUIModifier.MatchType = .exactMatch
    ) -> Bool {

        self.hasModifier(
            anyOf: [
                SwiftUIModifier(
                    name: "foregroundColor",
                    arguments: [
                        .init(
                            name: "",
                            values: colorOptions,
                            matchType: matchType
                        )
                    ]
                )
            ],
            in: file
        )
    }

    /// Determine whether dictionary has black `foregroundColor` modifier.
    func hasBlackForeground(in file: SwiftLintFile) -> Bool {

        let colorOptions = [".black", "Color.black"]
        return self.hasForegroundColor(with: colorOptions, in: file)
    }

    /// Determine wether dictionary has `foregroundColor` modifier which
    /// is passed a variable.
    func hasVariableForeground(in file: SwiftLintFile) -> Bool {

        guard self.hasForegroundColor(in: file) else {
            return false
        }

        let colorOptions = ["Color.", "."]
        return !self.hasForegroundColor(
            with: colorOptions,
            in: file,
            matchType: .prefix
        )
    }
}

// MARK: - SourceKittenDictionary extension background

private extension SourceKittenDictionary {

    /// Whether dictionary has some kind of modifier that modifies
    /// the background of the view, i.e. `background` or `tint`.
    var hasBackgroundModifier: Bool {

        let backgroundNameOptions = [
            ".background\n",
            ".background",
            ".tint"
        ]

        guard let name = self.name else {
            return false
        }

        for nameOption in backgroundNameOptions
        where name.contains(nameOption) {
            return true
        }
        return false
    }

    /// Determine whether dictionary has background modifier that is passed
    /// the given `colorOptions`, i.e. `background(_:ignoresSafeAreaEdges)`,
    /// `background(_:in:fillStyle:)`, or `tint(_:)`.
    func hasBackgroundModifier(
        with colorOptions: [String],
        in file: SwiftLintFile
    ) -> Bool {

        self.hasModifier(
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
        let hasModifierWithWhiteColorArgument = self.hasBackgroundModifier(
            with: colorOptions,
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

    /// Determine whether dictionary has some kind of background modifier which is
    /// not passed a `Color` option, e.g. a variable or something similar.
    func hasVariableBackgroundModifier(in file: SwiftLintFile) -> Bool {

        // make sure that dictionary has some background modifier at all
        guard self.hasBackgroundModifier else {
            return false
        }

        // possible options if passed argument is not a variable or sth similar
        let colorOptions = ["Color.", "."]

        // check if dictionary has modifier that does not have a closure
        let hasNonClosureModifierWithoutVariable = self.hasBackgroundModifier(
            with: colorOptions,
            in: file
        )

        if hasNonClosureModifierWithoutVariable {
            return false
        }

        // check closures
        guard let argumentValue = self.getSingleUnnamedArgumentValue(in: file) else {
            return false
        }

        guard argumentValue.contains("Color.") else {
            return true
        }

        return false
    }
}
