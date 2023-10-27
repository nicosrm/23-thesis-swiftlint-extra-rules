//
//  OrnamentSystemWarningRule+Examples.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore

extension OrnamentSystemWarningRule {

    static var nonTriggeringExamples: [Example] {
        [
            Example(
            """
            struct MyView: View {
                var body: some View {
                    Text("Hello World")
                        .toolbar {
                            Button("Inside ornament", action: {})
                        }
                }
            }
            """
            ),
            Example(
            """
            struct MyView: View {
                var body: some View {
                    Text("Hello World")
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
                        ↓Text("Hello World")
                            .ornament(
                                visibility: .hidden,
                                attachmentAnchor: .scene(.bottom),
                            ) {
                                Button("Inside ornament", action: {})
                            }
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        ↓Text("Hello World")
                            .ornament(
                                visibility: Visibility.hidden,
                                attachmentAnchor: .scene(.bottom),
                            ) {
                                Button("Inside ornament", action: {})
                            }
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        ↓Text("Hello World")
                            .ornament(
                                visibility: .hidden,
                                attachmentAnchor: .scene(.bottom),
                                contentAlignment: .center
                            ) {
                                Button("Inside ornament", action: {})
                            }
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        ↓Text("Hello World")
                            .ornament(
                                visibility: .hidden,
                                attachmentAnchor: .scene(.bottom),
                                contentAlignment: .center,
                                ornament: {
                                    Button("Inside ornament", action: {})
                                }
                            )
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var visibility = Visibility.hidden
                    var body: some View {
                        ↓Text("Hello World")
                            .ornament(
                                visibility: visibility,
                                attachmentAnchor: .scene(.bottom),
                            ) {
                                Button("Inside ornament", action: {})
                            }
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var visibility = Visibility.visible
                    var body: some View {
                        ↓Text("Hello World")
                            .ornament(
                                visibility: visibility,
                                attachmentAnchor: .scene(.bottom),
                            ) {
                                Button("Inside ornament", action: {})
                            }
                    }
                }
                """
            )
        ]
    }
}

