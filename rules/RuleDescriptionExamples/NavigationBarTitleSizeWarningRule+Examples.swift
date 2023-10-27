//
//  NavigationBarTitleSizeWarningRule+Examples.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore

extension NavigationBarTitleSizeWarningRule {

    static var nonTriggeringExamples: [Example] {
        [
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        Text("no navigation title")
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
                        NavigationLink {
                            Text("Destination")
                        } label: {
                            Text("Label")
                        }
                        .navigationTitle↓("Title")
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        NavigationStack {
                            Text("Hello world!")
                        }
                        .navigationTitle↓("Title")
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        NavigationStack {
                            Text("Hello world!")
                                .navigationTitle↓("Title")
                        }
                    }
                }
                """
            )
        ]
    }
}
