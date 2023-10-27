//
//  OrnamentWidthWarningRule.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore
import SourceKittenFramework

/// Rule that produces a warning for every occurence of `.ornament` and `.toolbar`
/// modifier. Intended to help investigating that the width of the ornament does
/// not exceed that of the window it is attached to.
///
/// Needs to be manually enabled via `.swiftlint.yml`.
struct OrnamentWidthWarningRule: ASTRule, ConfigurationProviderRule, OptInRule {

    var configuration = SeverityConfiguration(.warning)

    static var description: RuleDescription {

        RuleDescription(
            identifier: "ornament_width_warning",
            name: "Ornament Width Warning",
            description: "Check that the width of ornaments should not exceed " +
                "the window it is attached to",
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

private extension OrnamentWidthWarningRule {

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

            if dictionary.hasOrnamentModifier(in: file) {
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

    /// Determine whether dictionary has `.ornament` or `.toolbar` modifier.
    ///
    /// - Returns: `true` if that is the case, `false` otherwise.
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
                ),
                SwiftUIModifier(
                    name: "toolbar",
                    arguments: [
                        .init(
                            name: "content",
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
