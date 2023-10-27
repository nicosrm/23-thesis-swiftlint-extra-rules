//
//  OrnamentBorderlessButtonRule.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore
import SourceKittenFramework

/// Rule that produces violations if a button in an ornament is bordered.
struct OrnamentBorderlessButtonRule: ASTRule, ConfigurationProviderRule {

    var configuration = SeverityConfiguration(.warning)

    static var description: RuleDescription {

        RuleDescription(
            identifier: "ornament_borderless_button",
            name: "Ornament Borderless Button",
            description: "Buttons in an ornament should be borderless",
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

private extension OrnamentBorderlessButtonRule {

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

            let isOrnament = dictionary.hasOrnamentModifier(in: file) ||
                dictionary.hasBottomOrnamentToolbarModifier(in: file)

            if isOrnament {
                if let content = dictionary.getSingleUnnamedArgumentValue(in: file) {
                    if content.contains(".bordered") {
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
            }

            violations.append(
                contentsOf: self.findViolations(
                    file: file,
                    substructure: dictionary.substructure
                )
            )
        }

        return violations
    }
}

// MARK: - SourceKittenDictionary extension

private extension SourceKittenDictionary {

    /// Determine whether dictionary has `ornament` modifier.
    ///
    /// - Returns: `true` if dictionary has `ornament` modifier, `false` otherwise.
    func hasOrnamentModifier(in file: SwiftLintFile) -> Bool {

        self.hasModifier(
            anyOf: [
                SwiftUIModifier(
                    name: "ornament",
                    arguments: [
                        .init(
                            name: "visibility",
                            required: false,
                            values: []
                        ),
                        .init(
                            name: "attachmentAnchor",
                            required: true,
                            values: []
                        ),
                        .init(
                            name: "contentAlignment",
                            required: false,
                            values: []
                        ),
                        .init(
                            name: "ornament",
                            required: false,
                            values: []
                        )
                    ]
                )
            ],
            in: file
        )
    }

    /// Determine whether dictionary has `toolbar` modifier which is an ornament,
    /// i.e. placed at the bottom.
    ///
    /// - Returns: `true` if that is the case, `false` otherwise.
    func hasBottomOrnamentToolbarModifier(in file: SwiftLintFile) -> Bool {

        let hasToolbarModifier = self.hasModifier(
            anyOf: [
                SwiftUIModifier(
                    name: "toolbar",
                    arguments: [
                        .init(
                            name: "content",
                            required: false,
                            values: []
                        )
                    ]
                )
            ],
            in: file
        )

        guard hasToolbarModifier else {
            return false
        }

        // get content of modifier
        guard let content = self.getSingleUnnamedArgumentValue(in: file) else {
            return false
        }

        guard content.contains(".bottomOrnament") ||
                content.contains("ToolbarItemPlacement.bottomOrnament") else {
            return false
        }

        return true
    }
}
