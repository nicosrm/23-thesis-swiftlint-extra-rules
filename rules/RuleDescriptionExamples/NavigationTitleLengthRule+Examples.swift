//
//  NavigationTitleLengthRule+Examples.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore

extension NavigationTitleLengthRule {

    static var nonTriggeringExamples: [Example] {
        [
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        Text("Hello")
                            .navigationTitle("Ok")
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        Text("Hello")
                            .navigationTitle("Edge Title Case")
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
                        Text("Hello World")
                            .navigationTitle(↓"A too long title")
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        Text("Hello World")
                            .navigationTitle(↓"Some Long Navigation Title")
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    private let title = "Some title"
                    var body: some View {
                        Text("Hello")
                            .navigationTitle(↓self.title)
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    private let title = "Some title"
                    var body: some View {
                        Text("Hello")
                            .navigationTitle(↓title)
                    }
                }
                """
            )
        ]
    }
}
