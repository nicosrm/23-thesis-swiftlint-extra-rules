//
//  OrnamentBorderlessButtonRule+Examples.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore

extension OrnamentBorderlessButtonRule {

    static var nonTriggeringExamples: [Example] {
        [
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        NavigationStack {
                            Text("View with a toolbar")
                                .ornament(attachmentAnchor: .scene(.bottom)) {
                                    Button("button", action: {})
                                }
                        }
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        NavigationStack {
                            Text("View with a toolbar")
                                .ornament(attachmentAnchor: .scene(.bottom)) {
                                    Button("button", action: {})
                                        .buttonStyle(.borderless)
                                }
                        }
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        NavigationStack {
                            Text("View with a toolbar")
                                .toolbar {
                                    ToolbarItemGroup(placement: .bottomOrnament) {
                                        Button("button", action: {})
                                    }
                                }
                        }
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        NavigationStack {
                            Text("View with a toolbar")
                                .toolbar {
                                    ToolbarItemGroup(placement: .bottomOrnament) {
                                        Button("button", action: {})
                                            .buttonStyle(.borderless)
                                    }
                                }
                        }
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        NavigationStack {
                            Text("View with a toolbar")
                                .toolbar {
                                    ToolbarItemGroup(placement: .bottomOrnament) {
                                        Text("No button at all")
                                    }
                                }
                        }
                    }
                }
                """
            ),
            Example(
                // not an ornament (placement != .bottomOrnament)
                """
                struct MyView: View {
                    var body: some View {
                        NavigationStack {
                            Text("View with a toolbar")
                                .toolbar {
                                    ToolbarItemGroup {
                                        Button("button", action: {})
                                            .buttonStyle(.bordered)
                                    }
                                }
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
                        NavigationStack {
                            ↓Text("View with a toolbar")
                                .ornament(attachmentAnchor: .scene(.bottom)) {
                                    Button("button", action: {})
                                        .buttonStyle(.bordered)
                                }
                        }
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        NavigationStack {
                            ↓Text("View with a toolbar")
                                .ornament(attachmentAnchor: .scene(.bottom)) {
                                    Button("button", action: {})
                                        .buttonStyle(.borderedProminent)
                                }
                        }
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        NavigationStack {
                            ↓Text("View with a toolbar")
                                .toolbar {
                                    ToolbarItemGroup(placement: .bottomOrnament) {
                                        Button("bordered", action: {})
                                            .buttonStyle(.bordered)
                                    }
                                }
                        }
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        NavigationStack {
                            ↓Text("View with a toolbar")
                                .toolbar {
                                    ToolbarItemGroup(placement: .bottomOrnament) {
                                        Button("prominent", action: {})
                                            .buttonStyle(.borderedProminent)
                                    }
                                }
                        }
                    }
                }
                """
            ),

        ]
    }
}
