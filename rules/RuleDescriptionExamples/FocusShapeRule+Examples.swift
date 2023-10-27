//
//  FocusShapeRule+Examples.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore

extension FocusShapeRule {

    static var nonTriggeringExamples: [Example] {
        [
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        Text("Hello World")
                            .onTapGesture {
                                print("hello")
                            }
                            .contentShape(.hoverEffect, Rectangle())
                            .hoverEffect(.automatic)
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        Text("Hello World")
                            .onTapGesture {
                                print("hello")
                            }
                            .contentShape(Rectangle())
                            .hoverEffect(.automatic)
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        Text("Hello World")
                            .onTapGesture {
                                print("hello")
                            }
                            .contentShape(Rectangle())
                            .hoverEffect()
                    }
                }
                """
            ),
            Example(
                // no onTapGesture
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
                // contentShape and hoverEffect is missing
                """
                struct MyView: View {
                    var body: some View {
                        ↓Text("Hello World")
                            .onTapGesture {
                                print("hello")
                            }
                    }
                }
                """
            ),
            Example(
                // contentShape and hoverEffect is missing
                """
                struct MyView: View {
                    var body: some View {
                        ↓Text("Hello World")
                            .onTapGesture(
                                count: 1,
                                perform: {
                                    print("hello")
                                }
                            )
                    }
                }
                """
            ),
            Example(
                // contentShape and hoverEffect is missing
                """
                struct MyView: View {
                    var url = URL(string: "example.com")!
                    var body: some View {
                        ↓Text("Hello World")
                            .onTapGesture(count: 1) {
                               print("hello")
                            }
                    }
                }
                """
            ),
            Example(
                // contentShape is missing
                """
                struct MyView: View {
                    var body: some View {
                        ↓Text("Hello World")
                            .onTapGesture {
                                print("hello")
                            }
                            .hoverEffect(.automatic)
                    }
                }
                """
            ),
            Example(
                // hoverEffect is missing
                """
                struct MyView: View {
                    var body: some View {
                        ↓Text("Hello World")
                            .onTapGesture {
                                print("hello")
                            }
                            .contentShape(.hoverEffect, Rectangle())
                    }
                }
                """
            ),
            Example(
                // hoverEffect is missing
                """
                struct MyView: View {
                    var body: some View {
                        ↓Text("Hello World")
                            .onTapGesture {
                                print("hello")
                            }
                            .contentShape(Rectangle())
                    }
                }
                """
            ),
            Example(
                // contentShape is missing
                """
                struct MyView: View {
                    var body: some View {
                        ↓Text("Hello World")
                            .onTapGesture {
                                print("hello")
                            }
                            .hoverEffect()
                    }
                }
                """
            )
        ]
    }
}
