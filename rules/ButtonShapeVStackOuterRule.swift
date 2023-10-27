//
//  ButtonShapeVStackOuterRule.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore
import SourceKittenFramework

/// Rule that produces violations for `VStack`s that contain buttons and do not modify
/// the entire `VStack` to make the buttons shaped like a rounded rectangle.
///
/// **NOTE:** The modifier has to be applied outside of the `VStack`!
struct ButtonShapeVStackOuterRule: ASTRule, ConfigurationProviderRule {

    var configuration = SeverityConfiguration(.warning)

    static var description: RuleDescription {
        RuleDescription(
            identifier: "button_shape_vstack_outer",
            name: "Button Shape VStack Outside Rule",
            description: "Buttons in a VStack should be shaped like a rounded rectangle",
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

private extension ButtonShapeVStackOuterRule {

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
                  dictionaryName.hasPrefix("VStack") else {

                // is not VStack -> search in substructures
                violations.append(
                    contentsOf: self.findViolations(
                        file: file,
                        substructure: dictionary.substructure
                    )
                )
                continue
            }

            guard dictionary.hasFilledButtonStyleModifier(in: file),
                  !dictionary.hasCapsuleButtonBorderShape(in: file),
                  !dictionary.hasCircleOrRectangleClipShape(in: file)
            else {

                let closureContainsButton = dictionary
                    .getSingleUnnamedArgumentValue(in: file)?.contains("Button(")

                let nameContainsButton = dictionaryName.contains("Button(")

                if nameContainsButton || (closureContainsButton == true) {

                    // contains button
                    violations.append(
                        StyleViolation(
                            ruleDescription: Self.description,
                            severity: self.configuration.severity,
                            location: Location(file: file, byteOffset: offset)
                        )
                    )
                }
                continue
            }
        }

        return violations
    }
}

// MARK: - SourceKittenDictionary extension

private extension SourceKittenDictionary {

    /// Determine whether dictionary has `.buttonStyle(_:)` modifier that receives
    /// `.bordered` or `.borderedProminent` as `style` argument.
    func hasFilledButtonStyleModifier(in file: SwiftLintFile) -> Bool {

        self.hasModifier(
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
    }

    /// Determine whether dictionary has `.buttonBorderShape(.capsule)` modifier.
    func hasCapsuleButtonBorderShape(in file: SwiftLintFile) -> Bool {

        self.hasModifier(
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
    }

    /// Determine whether dictionary has `.clipShape` modifier with either
    /// `Circle()` or `Rectangle()` as argument.
    func hasCircleOrRectangleClipShape(in file: SwiftLintFile) -> Bool {

        self.hasModifier(
            anyOf: [
                SwiftUIModifier(
                    name: "clipShape",
                    arguments: [
                        .init(
                            name: "",
                            values: [
                                "Circle()",
                                "Rectangle()"
                            ]
                        )
                    ]
                )
            ],
            in: file
        )
    }
}
