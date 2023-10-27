//
//  ButtonShapeVStackOuterRule+Examples.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore

extension ButtonShapeVStackOuterRule {

    static var nonTriggeringExamples: [Example] {
        [
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        VStack {
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                        }
                        .buttonStyle(.bordered)
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        VStack {
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        VStack {
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle)
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        VStack {
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle)
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        VStack {
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle(radius: 8.0))
                    }
                }
                """
            ),
        ]
    }

    static var triggeringExamples: [Example] {
        [
            Example(
                // no modifier
                """
                struct MyView: View {
                    var body: some View {
                        ↓VStack {
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                        }
                    }
                }
                """
            ),
            Example(
                // pill-shaped
                """
                struct MyView: View {
                    var body: some View {
                        ↓VStack {
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                    }
                }
                """
            ),
            Example(
                // missing filled `.buttonStyle`
                """
                struct MyView: View {
                    var body: some View {
                        ↓VStack {
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                        }
                        .buttonBorderShape(.roundedRectangle)
                    }
                }
                """
            ),
            Example(
                // circular
                """
                struct MyView: View {
                    var body: some View {
                        ↓VStack {
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                        }
                        .background(.blue)
                        .clipShape(Circle())
                    }
                }
                """
            ),
            Example(
                // rectangle
                """
                struct MyView: View {
                    var body: some View {
                        ↓VStack {
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                        }
                        .background(.blue)
                        .clipShape(Rectangle())
                    }
                }
                """
            )
        ]
    }
}
