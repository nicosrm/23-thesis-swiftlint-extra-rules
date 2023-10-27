//
//  ToggleButtonStyleWarningRule+Examples.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore

extension ToggleButtonStyleWarningRule {

    static var nonTriggeringExamples: [Example] {
        [
            Example(
            """
            struct MyView: View {
                var body: some View {
                    Button("hello", action: {})
                        .background(.white)
                }
            }
            """
            ),
            Example(
            """
            struct MyView: View {
                var body: some View {
                    Button("hello", action: {})
                        .foregroundColor(.black)
                }
            }
            """
            ),
            Example(
            """
            struct MyView: View {
                var body: some View {
                    Button("hello", action: {})
                        .foregroundColor(.white)
                        .background(.black)
                }
            }
            """
            ),
            Example(
            """
            struct MyView: View {
                var body: some View {
                    Button("hello", action: {})
                }
            }
            """
            ),
            Example(
            """
            struct MyView: View {
                var body: some View {
                    Button("hello", action: {})
                        .foregroundColor(.black)
                        .background(content: { Color.black })
                }
            }
            """
            ),
            Example(
            """
            struct MyView: View {
                var body: some View {
                    Button("hello", action: {})
                        .foregroundColor(.black)
                        .background {
                            Color.black
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
                        ↓Button("hello", action: {})
                            .foregroundColor(.black)
                            .background(.white)
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        ↓Button("hello", action: {})
                            .foregroundColor(.black)
                            .background(.white, ignoresSafeAreaEdges: [])
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        ↓Button("hello", action: {})
                            .foregroundColor(Color.black)
                            .background(.white)
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        ↓Button("hello", action: {})
                            .foregroundColor(.black)
                            .background(Color.white)
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        ↓Button("hello", action: {})
                            .foregroundColor(.black)
                            .background(.white, in: Rectangle())
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        ↓Button("hello", action: {})
                            .foregroundColor(.black)
                            .background(.white, in: Rectangle(), fillStyle: FillStyle())
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        ↓Button("hello", action: {})
                            .foregroundColor(.black)
                            .background {
                                Color.white
                            }
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        ↓Button("hello", action: {})
                            .foregroundColor(.black)
                            .background(alignment: .center) {
                                Color.white
                            }
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        ↓Button("hello", action: {})
                            .foregroundColor(.black)
                            .background(content: { Color.white })
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        ↓Button("hello", action: {})
                            .foregroundColor(.black)
                            .background(
                                alignment: .center,
                                content: { Color.white }
                            )
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        VStack {
                            Button("hello", action: {})
                            Button("hello", action: {})
                        }
                        .foregroundColor(.black)
                        .background(.white)
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        VStack {
                            Button("hello", action: {})
                            Button("hello", action: {})
                        }
                        .background(.white)
                        .foregroundColor(.black)
                    }
                }
                """
            )
        ]
    }
}
