//
//  FeedbackSoundRule.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore
import SourceKittenFramework

/// Rule that produces violations if `onTapGesture` is used without providing
/// a feedback sound.
struct FeedbackSoundRule: ASTRule, ConfigurationProviderRule {

    var configuration = SeverityConfiguration(.warning)

    static let description = RuleDescription(
        identifier: "feedback_sound",
        name: "Feedback sound for onTapGesture",
        description: "A feedback sound should be provided when using " +
        "onTapGesture",
        kind: .style,
        nonTriggeringExamples: Self.nonTriggeringExamples,
        triggeringExamples: Self.triggeringExamples
    )

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

private extension FeedbackSoundRule {

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

            if dictionary.hasOnTapGestureModifierWithoutSound(in: file) {
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

    /// Determine whether dictionary has `onTapGesture` modifier that does not
    /// play a sound.
    ///
    /// Returns `false` if dictionary does not have `onTapGesture` modifier.
    ///
    /// Checks for occurences of `AudioServicePlaySystemSound` and `AVAudioPlayer(contentsOf:)`.
    /// If those are not included, returns `true`.
    func hasOnTapGestureModifierWithoutSound(in file: SwiftLintFile) -> Bool {

        let hasOnTapGesture = self.hasModifier(
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

        guard hasOnTapGesture else {
            // has no `onTapGesture` at all
            return false
        }

        // check if closure includes playing a sound

        guard let closure = self.getSingleUnnamedArgumentValue(in: file) else {
            return true
        }

        if closure.contains("AudioServicesPlaySystemSound") {
            // closure plays sound
            return false
        }

        if closure.contains("AVAudioPlayer(contentsOf:") &&
            closure.contains(".play()") {
            // closure plays sound
            return false
        }

        // has modifier but does not play sound
        return true
    }
}
