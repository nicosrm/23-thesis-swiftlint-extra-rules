//
//  OrnamentWidthWarningRule+Examples.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore

extension OrnamentWidthWarningRule {

    static var nonTriggeringExamples: [Example] {
        [
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
                        .ornament(attachmentAnchor: .scene(.bottom)) {
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
                            visibility: .visible,
                            attachmentAnchor: .scene(.bottom)
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
                            visibility: .visible,
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
                            visibility: .visible,
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
                var body: some View {
                    ↓Text("Hello World")
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
                    ↓Text("Hello World")
                        .toolbar(content: {
                            Button("Inside ornament", action: {})
                        })
                }
            }
            """
            )
        ]
    }
}
