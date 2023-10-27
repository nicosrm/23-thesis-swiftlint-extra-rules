//
//  OrnamentVisibilityRule.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore
import SourceKittenFramework

/// Rule that produces violation if ornament is initialised with hidden visibility.
/// Also violates if a variable is passed to `visibility` parameter.
struct OrnamentVisibilityRule: ASTRule, ConfigurationProviderRule {

    var configuration = SeverityConfiguration(.warning)

    static var description: RuleDescription {

        RuleDescription(
            identifier: "ornament_visibility",
            name: "Ornament Visibility",
            description: "Make sure that ornaments should generally not be hidden",
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

// MARK: Private functions

private extension OrnamentVisibilityRule {

    /// Recursively check file for violations.
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

            if dictionary.hasHiddenOrnamentModifier(in: file) {
                violations.append(
                    StyleViolation(
                        ruleDescription: Self.description,
                        severity: self.configuration.severity,
                        location: Location(file: file, byteOffset: offset)
                    )
                )
            } else if dictionary.hasOrnamentModifierWithSpecifiedVisibility(in: file) &&
                        !dictionary.hasVisibleOrAutomaticOrnamentModifier(in: file) {
                // has `.ornament` modifier with specified visbility
                // visibility is not `.hidden` (first `if` branch)
                // visibility is not `.visible` or `.automatic`
                // => must be a variable
                // => needs to be checked
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

    /// Determine whether dictionary has `.ornament` modifier with specified
    /// `visibility` modifier.
    ///
    /// It does not matter what is passed as `visibility` to return `true`. It is
    /// only determined whether the parameter is passed or not.
    ///
    /// - Returns: `true` if dictionary has `ornament` modifier with specified
    ///     `visibility` parameter, `false` otherwise
    func hasOrnamentModifierWithSpecifiedVisibility(in file: SwiftLintFile) -> Bool {

        self.hasModifier(
            anyOf: [
                SwiftUIModifier(
                    name: "ornament",
                    arguments: [
                        .init(
                            name: "visibility",
                            required: true,     // by default `.automatic`
                                                // -> in this case it's required
                            values: []
                        ),
                        .init(
                            name: "attachmentAnchor",
                            values: []
                        ),
                        .init(
                            name: "contentAlignment",
                            required: false,
                            values: []
                        ),
                        .init(
                            name: "ornament",
                            required: false,    // can be trailing closure
                            values: []
                        )
                    ]
                )
            ],
            in: file
        )
    }

    /// Determine whether dictionary has `.ornament` modifier with visibility
    /// `.visible` or `.automatic`.
    ///
    /// - Returns: `true` if `self` has `.visible` or `.automatic` `.ornament`
    ///     modifier, `false` otherwise
    func hasVisibleOrAutomaticOrnamentModifier(in file: SwiftLintFile) -> Bool {

        self.hasModifier(
            anyOf: [
                SwiftUIModifier(
                    name: "ornament",
                    arguments: [
                        .init(
                            name: "visibility",
                            required: true,     // by default `.automatic`
                                                // -> in this case it's required
                            values: [
                                ".visible",
                                "Visibility.visible",
                                ".automatic",
                                "Visibility.automatic"
                            ]
                        ),
                        .init(
                            name: "attachmentAnchor",
                            values: []
                        ),
                        .init(
                            name: "contentAlignment",
                            required: false,
                            values: []
                        ),
                        .init(
                            name: "ornament",
                            required: false,    // can be trailing closure
                            values: []
                        )
                    ]
                )
            ],
            in: file
        )
    }

    /// Determine if dictionary has `.ornament`-Modifier with `.hidden` visibility.
    ///
    /// - Returns: `true` if that is the case, `false` otherwise
    func hasHiddenOrnamentModifier(in file: SwiftLintFile) -> Bool {

        self.hasModifier(
            anyOf: [
                SwiftUIModifier(
                    name: "ornament",
                    arguments: [
                        .init(
                            name: "visibility",
                            required: true,     // by default `.automatic`
                                                // -> in this case it's required
                            values: [".hidden", "Visibility.hidden"]
                        ),
                        .init(
                            name: "attachmentAnchor",
                            values: []
                        ),
                        .init(
                            name: "contentAlignment",
                            required: false,
                            values: []
                        ),
                        .init(
                            name: "ornament",
                            required: false,    // can be trailing closure
                            values: []
                        )
                    ]
                )
            ],
            in: file
        )
    }
}
