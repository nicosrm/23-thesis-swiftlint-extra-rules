//
//  TabItemNonEmptyLabelRule+Examples.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore

extension TabItemNonEmptyLabelRule {

    static var nonTriggeringExamples: [Example] {
        [
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        TabView {
                            Text("Tab 1")
                                .tabItem {
                                    Label("some text", systemImage: "heart.fill")
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
                        TabView {
                            Text("Tab 1")
                                .tabItem {
                                    Text("some text")
                                    Image(systemName: "heart.fill")
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
                        TabView {
                            ↓Text("Tab 1")
                                .tabItem {
                                    Label("", systemImage: "heart.fill")
                                }
                        }
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var labelText = "some text"
                    var body: some View {
                        TabView {
                            ↓Text("Tab 1")
                                .tabItem {
                                    Label(labelText, systemImage: "heart.fill")
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
                        TabView {
                            ↓Text("Tab 1")
                                .tabItem {
                                    Label(" ", systemImage: "heart.fill")
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
                        TabView {
                            ↓Text("Tab 1")
                                .tabItem {
                                    Label(" ", systemImage: "heart.fill")
                                }
                            ↓Text("Tab 2")
                                .tabItem {
                                    Label("", systemImage: "heart.fill")
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
                        TabView {
                            Text("Tab 1")
                                .tabItem {
                                    Label("some text", systemImage: "heart.fill")
                                }
                            ↓Text("Tab 2")
                                .tabItem {
                                    Label("", systemImage: "heart.fill")
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
                        TabView {
                            Text("Tab 1")
                                .tabItem {
                                    Label("some text", systemImage: "heart.fill")
                                }
                            ↓Text("Tab 2")
                                .tabItem {
                                    Text("some text without image")
                                }
                        }
                    }
                }
                """
            )
        ]
    }
}
