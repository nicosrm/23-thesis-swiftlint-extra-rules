//
//  SidebarInitiallyVisibleRule.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore
import SwiftSyntax

/// Rule that produces violation for every occurence of `NavigationSplitView` initialiser with
/// specified `columnVisibility` that is either a variable or hides it the sidebar.
struct SidebarInitiallyVisibleRule: ConfigurationProviderRule, SwiftSyntaxRule {

    var configuration = SeverityConfiguration(.warning)

    static var description: RuleDescription {

        RuleDescription(
            identifier: "sidebar_initially_visible",
            name: "Sidebar Initially Visible",
            description: "Sidebars should not be hidden by default. " +
            "If passing a variable please make sure not to initialise it" +
            "with `.detailOnly` or in case of a three column sidebar " +
            "with `.doubleColumn`",
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

private extension SidebarInitiallyVisibleRule {

    final class Visitor: ViolationsSyntaxVisitor {

        override func visitPost(_ node: FunctionCallExprSyntax) {

            guard node.isNavigationSplitView else {
                return
            }

            for argument in node.argumentList {

                guard let label = argument.label?.description,
                      label.hasSuffix("columnVisibility") else {
                    continue
                }

                guard !argument.isBinding && !argument.isDetailOnly else {
                    self.violations.append(argument.expression.positionAfterSkippingLeadingTrivia)
                    continue
                }

                if node.isThreeColumnNaigationSplitView,
                   argument.isDoubleColumn {
                    self.violations.append(argument.expression.positionAfterSkippingLeadingTrivia)
                    continue
                }
            }
        }
    }
}

// MARK: - FunctionCallExprSyntax extension

private extension FunctionCallExprSyntax {

    var isNavigationSplitView: Bool {

        guard let calledExpression = self.calledExpression
            .as(IdentifierExprSyntax.self) else {
            return false
        }
        return calledExpression.identifier.text == "NavigationSplitView"
    }

    var isThreeColumnNaigationSplitView: Bool {

        guard self.isNavigationSplitView else {
            return false
        }

        guard let closures = self.additionalTrailingClosures else {
            return false
        }
        return closures.contains { $0.label.text == "content" }
    }
}

// MARK: - TupleExprElementSyntax extension

private extension TupleExprElementSyntax {

    var isBinding: Bool {

        guard let expression = self.expression.as(IdentifierExprSyntax.self) else {
            return false
        }
        return expression.identifier.description.contains("$")
    }

    var isDetailOnly: Bool {

        guard let expression = self.expression.as(MemberAccessExprSyntax.self) else {
            return false
        }
        return expression.name.text.hasSuffix("detailOnly")
    }

    var isDoubleColumn: Bool {

        guard let expression = self.expression.as(MemberAccessExprSyntax.self) else {
            return false
        }
        return expression.name.text.hasSuffix("doubleColumn")
    }
}
