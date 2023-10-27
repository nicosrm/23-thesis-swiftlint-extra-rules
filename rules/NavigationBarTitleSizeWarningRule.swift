//
//  NavigationBarTitleSizeWarningRule.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore
import SwiftSyntax

/// Rule that prodouces violation for every occurence of `navigationTitle` to suggest
/// checking that the recommended size is applied.
struct NavigationBarTitleSizeWarningRule: ConfigurationProviderRule, SwiftSyntaxRule, OptInRule {

    var configuration = SeverityConfiguration(.warning)

    static var description: RuleDescription {

        RuleDescription(
            identifier: "navigation_bar_title_size_warning",
            name: "Navigation Bar Title Size Warning",
            description: "Check that root navigation views should have `.large`, " +
                "everything else `.inline` navigation title display mode. " +
                "If it's set to `.automatic` please ensure the rule. " +
                "If a variable is passed consider convertig it to a constant " +
                "and make sure it is set accordingly",
            kind: .style,
            nonTriggeringExamples: Self.nonTriggeringExamples,
            triggeringExamples: Self.triggeringExamples
        )
    }

    func makeVisitor(file: SwiftLintFile) -> ViolationsSyntaxVisitor {
        Visitor(viewMode: .sourceAccurate)
    }
}

// MARK: - Visitor

private extension NavigationBarTitleSizeWarningRule {

    final class Visitor: ViolationsSyntaxVisitor {

        override func visitPost(_ node: FunctionCallExprSyntax) {

            guard let titleDisplayModeCall = node.calledExpression
                .as(MemberAccessExprSyntax.self),
                  titleDisplayModeCall.name.text == "navigationTitle" else {
                // not `navigationTitle` call
                return
            }

            self.violations.append(titleDisplayModeCall.endPositionBeforeTrailingTrivia)
        }
    }
}
