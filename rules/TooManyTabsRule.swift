//
//  TooManyTabsRule.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore
import SourceKittenFramework

/// Rule that produces violation if a `TabView` has more than 8 tab items.
struct TooManyTabsRule: ASTRule, ConfigurationProviderRule {

    var configuration = SeverityConfiguration(.warning)

    static var description: RuleDescription {

        RuleDescription(
            identifier: "too_many_tabs",
            name: "Too Many Tabs",
            description: "Defined more than \(threshold) tabs. Consider to " +
                "extract to a side bar",
            kind: .style,
            nonTriggeringExamples: Self.nonTriggeringExamples,
            triggeringExamples: Self.triggeringExamples
        )
    }

    static let threshold = 8

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

        var violations = [StyleViolation]()

        let tabItemCount = self.countTabItems(
            file: file,
            substructure: dictionary.substructure
        )

        guard let offset = dictionary.offset else {
            return []
        }

        if tabItemCount > Self.threshold {
            violations.append(
                StyleViolation(
                    ruleDescription: Self.description,
                    severity: self.configuration.severity,
                    location: Location(file: file, byteOffset: offset)
                )
            )
        }

        return violations
    }
}

// MARK: - Private extension

private extension TooManyTabsRule {

    /// Recursively count occurances of `tabItem` modifier of `substructure` in `file`.
    func countTabItems(
        file: SwiftLintFile,
        substructure: [SourceKittenDictionary]
    ) -> Int {

        var count = 0

        for dictionary in substructure {

            guard dictionary.hasTabItemModifier(in: file) else {
                if dictionary.substructure.isNotEmpty {
                    // recursively count in substructures
                    count += self.countTabItems(
                        file: file,
                        substructure: dictionary.substructure
                    )
                }
                continue
            }
            count += 1
        }

        return count
    }
}

// MARK: - SourceKittenDictionary extension

private extension SourceKittenDictionary {

    /// Determine whether dictionary has `tabItem` modifier.
    func hasTabItemModifier(in file: SwiftLintFile) -> Bool {

        self.hasModifier(
            anyOf: [
                SwiftUIModifier(
                    name: "tabItem",
                    arguments: [
                        .init(
                            name: "",           // content
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
