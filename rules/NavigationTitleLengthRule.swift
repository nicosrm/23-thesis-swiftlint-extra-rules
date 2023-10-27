//
//  NavigationTitleLengthRule.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore
import SwiftSyntax

/// Rule that produces violation if `navigationTitle` is passed a variable or a String with
/// more than 15 characters.
struct NavigationTitleLengthRule: ConfigurationProviderRule, SwiftSyntaxRule {

    var configuration = SeverityConfiguration(.warning)

    static var description: SwiftLintCore.RuleDescription {

        RuleDescription(
            identifier: "navigation_title_length",
            name: "Navigation Title Length",
            description: "Navigation titles should not be longer than 15 characters. " +
                "If not directly passing a String, please check variable or suchlike",
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

private extension NavigationTitleLengthRule {

    final class Visitor: ViolationsSyntaxVisitor {

        override func visitPost(_ node: FunctionCallExprSyntax) {

            // make sure that `navigationTitle` is called
            guard let memberAccess = node.calledExpression.as(MemberAccessExprSyntax.self),
                  memberAccess.name.text == "navigationTitle" else {
                return
            }

            // iterate on arguments
            for argument in node.argumentList {

                if let _ = argument.expression.as(StringLiteralExprSyntax.self) {
                    // string directly passed
                    self.findDirectStringViolations(for: argument)
                } else if let memberAccess = argument.expression.as(MemberAccessExprSyntax.self) {
                    // member access variable, e.g. self.variable / viewmodel.variable
                    violations.append(memberAccess.positionAfterSkippingLeadingTrivia)
                } else if let identifierExpression = argument.expression
                    .as(IdentifierExprSyntax.self) {
                    // accessing direct variable (e.g. `navigationTitle(title)`
                    violations.append(identifierExpression.positionAfterSkippingLeadingTrivia)
                }
            }
        }
    }
}

// MARK: - Visitor extension

private extension NavigationTitleLengthRule.Visitor {

    /// Append violations for string argument if it is longer than 15 characters.
    func findDirectStringViolations(for argument: TupleExprElementListSyntax.Element) {

        // get string literal of argument
        guard let stringLiteral = argument.expression
            .as(StringLiteralExprSyntax.self) else {
            return
        }

        // iterate over string segments
        for segment in stringLiteral.segments {

            // violation starting from > 15
            guard segment.description.count > 15 else {
                return
            }

            // add violation
            violations.append(stringLiteral.positionAfterSkippingLeadingTrivia)
        }
    }
}
