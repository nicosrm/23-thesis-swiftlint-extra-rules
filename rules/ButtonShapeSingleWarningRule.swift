//
//  ButtonShapeSingleWarningRule.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore
import SourceKittenFramework

/// Rule that produces violations if a button is not directly modified to make it circle-
/// or pill-shaped. Can be ignored if button appears in a stack.
struct ButtonShapeSingleWarningRule: ASTRule, ConfigurationProviderRule, OptInRule {

    var configuration = SeverityConfiguration(.warning)

    static var description: RuleDescription {
        RuleDescription(
            identifier: "button_shape_single_warning",
            name: "Button Shape Single Warning",
            description: "Pay attention that a button that is not stacked should generally " +
                "be circular or pill shaped. Ignore this warning if button appears in a stack",
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

private extension ButtonShapeSingleWarningRule {

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

            guard let dictionaryName = dictionary.name,
                  dictionaryName.contains("Button") else {

                // is not button -> search deeper
                violations.append(
                    contentsOf: self.findViolations(
                        file: file,
                        substructure: dictionary.substructure
                    )
                )
                continue
            }

            guard dictionary.hasCapsuleButtonBorderShape(in: file) ||
                    dictionary.hasCapsuleOrCircleClipShapeModifier(in: file) else {

                violations.append(
                    StyleViolation(
                        ruleDescription: Self.description,
                        severity: self.configuration.severity,
                        location: Location(file: file, byteOffset: offset)
                    )
                )
                continue
            }
        }

        return violations
    }
}

// MARK: - SourceKittenDictionary extension

private extension SourceKittenDictionary {

    /// Determine whether dictionary has `.clipShape(Capsule())` or `.clipShape(Circle())` modifier.
    func hasCapsuleOrCircleClipShapeModifier(in file: SwiftLintFile) -> Bool {

        self.hasModifier(
            anyOf: [
                SwiftUIModifier(
                    name: "clipShape",
                    arguments: [
                        .init(
                            name: "",
                            values: [
                                ".capsule",
                                "Capsule()",
                                ".circle",
                                "Circle()"
                            ]
                        )
                    ]
                )
            ],
            in: file
        )
    }

    /// Determine whether dictionary has capsule button border shape and filled button style.
    func hasCapsuleButtonBorderShape(in file: SwiftLintFile) -> Bool {

        let hasFilledButtonStyle = self.hasModifier(
            anyOf: [
                SwiftUIModifier(
                    name: "buttonStyle",
                    arguments: [
                        .init(
                            name: "",
                            values: [
                                ".bordered",
                                "BorderedButtonStyle.bordered",
                                ".borderedProminent",
                                "BorderedButtonStyle.borderedProminent"
                            ]
                        )
                    ]
                )
            ],
            in: file
        )

        guard hasFilledButtonStyle else {
            return false
        }

        let hasBorderShapeModifier = self.hasModifier(
            anyOf: [
                SwiftUIModifier(
                    name: "buttonBorderShape",
                    arguments: [
                        .init(
                            name: "",
                            values: [
                                ".capsule",
                                "ButtonBorderShape.capsule"
                            ]
                        )
                    ]
                )
            ],
            in: file
        )

        return hasBorderShapeModifier
    }
}
