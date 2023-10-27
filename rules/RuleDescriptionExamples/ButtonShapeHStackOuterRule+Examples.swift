//
//  ButtonShapeHStackOuterRule+Examples.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore

extension ButtonShapeHStackOuterRule {

    static var nonTriggeringExamples: [Example] {
        [
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        HStack {
                            Button("capsule", action: {})
                            Button("capsule", action: {})
                            Button("capsule", action: {})
                        }
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
                        HStack {
                            Button("capsule", action: {})
                            Button("capsule", action: {})
                            Button("capsule", action: {})
                        }
                        .clipShape(Capsule())
                        .buttonStyle(.bordered)
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        HStack {
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
                """
                struct MyView: View {
                    var body: some View {
                        HStack {
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                            Button("bordered", action: {})
                        }
                        .buttonBorderShape(.capsule)
                        .buttonStyle(.bordered)
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        HStack {
                            Text("No Buttons")
                            Text("No triggering")
                        }
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
                        ↓HStack {
                            Button("capsule", action: {})
                            Button("capsule", action: {})
                            Button("capsule", action: {})
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
                        ↓HStack {
                            Button("capsule", action: {})
                            Button("capsule", action: {})
                            Button("capsule", action: {})
                        }
                        .clipShape(Capsule())
                    }
                }
                """
            ),
            Example(
            """
            struct MyView: View {
                var body: some View {
                    HStack {
                        Button("bordered", action: {})
                        Button("bordered", action: {})
                        Button("bordered", action: {})
                    }
                    .buttonBorderShape(.capsule)
                }
            }
            """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        ↓HStack {
                            Button("bordered", action: {})
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.capsule)
                            Button("bordered", action: {})
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.capsule)
                            Button("bordered", action: {})
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.capsule)
                        }
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        ↓HStack {
                            Button("capsule", action: {})
                                .clipShape(Capsule())
                            Button("capsule", action: {})
                                .clipShape(Capsule())
                            Button("capsule", action: {})
                                .clipShape(Capsule())
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
                        ↓HStack {
                            Button("rounded", action: {})
                                .buttonStyle(.bordered)
                            Button("rounded", action: {})
                                .buttonStyle(.bordered)
                            Button("rounded", action: {})
                                .buttonStyle(.bordered)
                        }
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        ↓HStack {
                            Button("rounded", action: {})
                            Button("rounded", action: {})
                            Button("rounded", action: {})
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
                        ↓HStack {
                            Button("rounded", action: {})
                            Button("rounded", action: {})
                            Button("rounded", action: {})
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
                        ↓HStack {
                            Button("rounded", action: {})
                            Button("rounded", action: {})
                            Button("rounded", action: {})
                        }
                    }
                }
                """
            )
        ]
    }
}
