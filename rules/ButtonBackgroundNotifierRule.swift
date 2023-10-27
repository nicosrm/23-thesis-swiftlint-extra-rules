//
//  ButtonBackgroundRule.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore
import SwiftSyntax

/// Rule that produces violations for every occurence of a `Button`.
struct ButtonBackgroundNotifierRule: ConfigurationProviderRule, OptInRule, SwiftSyntaxRule {

    var configuration = SeverityConfiguration(.warning)

    static var description: RuleDescription {

        RuleDescription(
            identifier: "button_background_notifier",
            name: "Button Background Notifier",
            description: "Pay attention to provide a discernible and constrasting background " +
                "shape and fill. If the button is displayed on glass, use a light background." +
                "If the button floats in space, use a glass material background",
            kind: .style,
            triggeringExamples: [
                Example(
                    """
                    struct MyView: View {
                        var body: some View {
                            ↓Button("Hello World", action: {})
                        }
                    }
                    """
                ),
                Example(
                    """
                    VStack {
                        ↓Button("one", action: {})
                        ↓Button("two", action: {})
                    }
                    """
                )
            ]
        )
    }

    func makeVisitor(file: SwiftLintFile) -> ViolationsSyntaxVisitor {
        Visitor(viewMode: .sourceAccurate)
    }
}

// MARK: - Visitor

private extension ButtonBackgroundNotifierRule {

    final class Visitor: ViolationsSyntaxVisitor {

        override func visitPost(_ node: IdentifierExprSyntax) {

            if node.identifier.text == "Button" {
                violations.append(node.positionAfterSkippingLeadingTrivia)
            }
        }
    }
}
