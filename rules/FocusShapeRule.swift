//
//  FocusShapeRule.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore
import SourceKittenFramework

/// Rule that produces violation if `onTapGesture` is used without providing a focus shape
/// via `contentShape` modifier.
struct FocusShapeRule: ASTRule, ConfigurationProviderRule {

    var configuration = SeverityConfiguration(.warning)

    static var description: RuleDescription {
        RuleDescription(
            identifier: "focus_shape",
            name: "Focus Shape",
            description: "A hover effect and focus shape should be provided " +
                "when using onTapGesture",
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

private extension FocusShapeRule {

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

            if dictionary.hasOnTapGestureModifier(in: file) {

                if !dictionary.hasHoverEffectModifier(in: file) ||
                    !dictionary.hasContentShapeModifier(in: file) {

                    violations.append(
                        StyleViolation(
                            ruleDescription: Self.description,
                            severity: self.configuration.severity,
                            location: Location(file: file, byteOffset: offset)
                        )
                    )
                } else {
                    continue
                }
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

    /// Determine whether dictionary has `contentShape` modifier.
    func hasContentShapeModifier(in file: SwiftLintFile) -> Bool {

        self.hasModifier(
            anyOf: [
                SwiftUIModifier(
                    name: "contentShape",
                    arguments: [
                        .init(
                            name: "",           // kind
                            required: false,
                            values: []
                        ),
                        .init(
                            name: "",           // shape
                            required: false,
                            values: []
                        ),
                        .init(
                            name: "eoFill",
                            required: false,
                            values: []
                        )
                    ]
                )
            ],
            in: file
        )
    }

    /// Determine whether dictionary has `hoverEffect` modifier.
    func hasHoverEffectModifier(in file: SwiftLintFile) -> Bool {

        self.hasModifier(
            anyOf: [
                SwiftUIModifier(
                    name: "hoverEffect",
                    arguments: [
                        .init(
                            name: "",
                            required: false,
                            values: []
                        )
                    ]
                )
            ],
            in: file
        )
    }

    /// Determine whether dictionary has `onTapGesture` modifier.
    func hasOnTapGestureModifier(in file: SwiftLintFile) -> Bool {

        self.hasModifier(
            anyOf: [
                SwiftUIModifier(
                    name: "onTapGesture",
                    arguments: [
                        .init(
                            name: "count",
                            required: false,
                            values: []
                        ),
                        .init(
                            name: "perform",
                            required: false,
                            values: []
                        )
                    ]
                )
            ],
            in: file
        )
    }
}
