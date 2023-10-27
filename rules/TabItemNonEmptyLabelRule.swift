//
//  TabItemNonEmptyLabelRule.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore
import SourceKittenFramework

/// Rule that produces violation if `tabItem` is not labeled with a text and image.
struct TabItemNonEmptyLabelRule: ASTRule, ConfigurationProviderRule {

    var configuration = SeverityConfiguration(.warning)

    static var description: RuleDescription {

        RuleDescription(
            identifier: "tab_item_non_empty_label",
            name: "Tab Item Non Empty Label",
            description: "A tabItem should not have a label without " +
                "a descriptive title text. " +
                "If passing a variable make sure it's not empty. " +
                "If content does not include a Label, convert Text to Label" +
                "and provide an icon",
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

private extension TabItemNonEmptyLabelRule {

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

            guard dictionary.hasTabItemModifier(in: file) else {

                if dictionary.substructure.isNotEmpty {
                    // recursively check substructures
                    violations.append(
                        contentsOf: self.findViolations(
                            file: file,
                            substructure: dictionary.substructure
                        )
                    )
                }
                continue
            }

            guard dictionary.tabItemModifierIsLabeled(in: file) else {
                // has `tabItem` modifier but no label in `content`
                // -> violation
                violations.append(
                    StyleViolation(
                        ruleDescription: Self.description,
                        severity: self.configuration.severity,
                        location: Location(file: file, byteOffset: offset)
                    )
                )
                continue
            }

            if dictionary.hasEmptyOrVariableLabel(in: file) {
                // title should not be empty
                // if title is a variable, user needs to check manually
                violations.append(
                    StyleViolation(
                        ruleDescription: Self.description,
                        severity: self.configuration.severity,
                        location: Location(file: file, byteOffset: offset)
                    )
                )
            }
        }

        return violations
    }
}

// MARK: - SourceKittenDictionary extension

private extension SourceKittenDictionary {

    /// Determine whether dictionary has `.tabItem` modifier.
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

    /// Determine whether dictionary has `.tabItem` modifier that includes either
    /// `Label` or `Text` and `Image`.
    ///
    /// **Note:** If `hasTabItemModifier` is `false` for this dictionary, returns `false`!
    func tabItemModifierIsLabeled(in file: SwiftLintFile) -> Bool {

        guard self.hasTabItemModifier(in: file) else {
            return false
        }

        // get content of modifier
        guard let content = self.getSingleUnnamedArgumentValue(in: file) else {
            return false
        }

        guard content.contains("Label(") || 
                (content.contains("Text(") && content.contains("Image(")) else {
            return false
        }

        return true
    }


    /// **Note:** If `tabItemModifierHasLabel(in:)` is `false` for this dictionary, returns `false`!
    func hasEmptyOrVariableLabel(in file: SwiftLintFile) -> Bool {

        guard self.tabItemModifierIsLabeled(in: file) else {
            return false
        }

        // get content of modifier
        guard let content = self.getSingleUnnamedArgumentValue(in: file) else {
            return false
        }

        guard let textArgument = content.split(separator: "Label(")
            .dropFirst()            // drop everything before `Label(`
            .first?                 // everything after `Label(`
            .split(separator: ",")  // split arguments of `Label`
            .first else {           // get first i.e. text argument
            return false
        }

        let isString = textArgument.contains("\"")
        guard isString else {
            // add violation if not passing a string directly
            // to make sure the user checks
            // e.g. variable, localized string etc.
            return true
        }

        // get inside of string without `"`
        // "some text"
        //  ^^^^^^^^^  => get that
        let textArgumentContent = textArgument.split(separator: "\"")

        guard textArgumentContent.isNotEmpty else {
            // empty text => violation
            return true
        }

        guard let stringTitle = textArgumentContent.first else {
            return false
        }

        // trim leading and trailing white spaces
        let sanitizedTitle = stringTitle.trimmingCharacters(in: [" "])

        if sanitizedTitle.isEmpty {
            return true
        }
        return false
    }
}
