//
//  ButtonShapeSingleWarningRule+Examples.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore

extension ButtonShapeSingleWarningRule {

    static var nonTriggeringExamples: [Example] {
        [
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        Button("capsule", action: {})
                            .buttonStyle(.bordered)
                            .clipShape(Capsule())
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        Button("capsule", action: {})
                            .buttonStyle(.bordered)
                            .clipShape(.capsule)
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        Button("capsule", action: {})
                            .buttonStyle(.bordered)
                            .clipShape(Circle())
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        Button("capsule", action: {})
                            .buttonStyle(.bordered)
                            .clipShape(.circle)
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        Button("capsule", action: {})
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        Button("capsule", action: {})
                            .buttonStyle(.bordered)
                            .buttonBorderShape(ButtonBorderShape.capsule)
                    }
                }
                """
            )
        ]
    }

    static var triggeringExamples: [Example] {
        [
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        ↓Button("capsule", action: {})
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        ↓Button("capsule", action: {})
                            .buttonStyle(.bordered)
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        ↓Button("capsule", action: {})
                            .buttonStyle(.bordered)
                            .clipShape(Rectangle())
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        ↓Button("capsule", action: {})
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.roundedRectangle)
                    }
                }
                """
            ),
        ]
    }
}
