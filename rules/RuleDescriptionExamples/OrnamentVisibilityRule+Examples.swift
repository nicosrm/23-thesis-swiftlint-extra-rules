//
//  OrnamentVisibilityRule+Examples.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore

extension OrnamentVisibilityRule {

    static var nonTriggeringExamples: [Example] {
        [
            Example(
            """
            struct MyView: View {
                var body: some View {
                    Text("Hello World")
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
                    Text("Hello World")
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
                    Text("Hello World")
                        .ornament(
                            visibility: .automatic,
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
                    Text("Hello World")
                        .ornament(
                            visibility: .automatic,
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
                    Text("Hello World")
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
                    Text("Hello World")
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
                                visibility: Visibility.hidden,
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
                                attachmentAnchor: .scene(.bottom)
                            ) {
                                Button("Inside ornament", action: {})
                            }
                    }
                }
                """
            ),
            Example(
                // triggering because passing a variable
                // that could be changed sometimes
                """
                struct MyView: View {
                    var visibility = Visibility.visible
                    var body: some View {
                        ↓Text("Hello World")
                            .ornament(
                                visibility: visibility,
                                attachmentAnchor: .scene(.bottom)
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
