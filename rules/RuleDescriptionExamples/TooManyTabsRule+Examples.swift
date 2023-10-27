//
//  TooManyTabsRule+Examples.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore

extension TooManyTabsRule {

    static var nonTriggeringExamples: [Example] {
        [
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        TabView {
                            Text("Tab 1")
                                .tabItem {
                                    Text("")
                                }
                            Text("Tab 2")
                                .tabItem {
                                    Label("", systemImage: "folder")
                                }
                            Text("Tab 3")
                                .tabItem {
                                    Text("")
                                }
                            Text("Tab 4")
                                .tabItem {
                                    Text("")
                                }
                            Text("Tab 5")
                                .tabItem {
                                    Text("")
                                }
                            Text("Tab 6")
                                .tabItem {
                                    Text("")
                                }
                            Text("Tab 7")
                                .tabItem {
                                    Text("")
                                }
                            Text("Tab 8")
                                .tabItem {
                                    Text("")
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
                                    Text("")
                                }
                            Text("Tab 2")
                                .tabItem {
                                    Label("", systemImage: "folder")
                                }
                            Text("Tab 3")
                                .tabItem {
                                    Text("")
                                }
                            Group {
                                Text("Tab 4")
                                    .tabItem {
                                        Text("")
                                    }
                                Text("Tab 5")
                                    .tabItem {
                                        Text("")
                                    }
                                Text("Tab 6")
                                    .tabItem {
                                        Text("")
                                    }
                            }
                            Text("Tab 7")
                                .tabItem {
                                    Text("")
                                }
                            Text("Tab 8")
                                .tabItem {
                                    Text("")
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
                ↓struct MyView: View {
                    var body: some View {
                        TabView {
                            Text("Tab 1")
                                .tabItem {
                                    Text("")
                                }
                            Text("Tab 2")
                                .tabItem {
                                    Label("", systemImage: "folder")
                                }
                            Text("Tab 3")
                                .tabItem {
                                    Text("")
                                }
                            Text("Tab 4")
                                .tabItem {
                                    Text("")
                                }
                            Text("Tab 5")
                                .tabItem {
                                    Text("")
                                }
                            Text("Tab 6")
                                .tabItem {
                                    Text("")
                                }
                            Text("Tab 7")
                                .tabItem {
                                    Text("")
                                }
                            Text("Tab 8")
                                .tabItem {
                                    Text("")
                                }
                            Text("Tab 9")
                                .tabItem {
                                    Text("")
                                }
                        }
                    }
                }
                """
            ),
            Example(
                """
                ↓struct MyView: View {
                    var body: some View {
                        TabView {
                            Text("Tab 1")
                                .tabItem {
                                    Text("")
                                }
                            Text("Tab 2")
                                .tabItem {
                                    Label("", systemImage: "folder")
                                }
                            Text("Tab 3")
                                .tabItem {
                                    Text("")
                                }
                            Group {
                                Text("Tab 4")
                                    .tabItem {
                                        Text("")
                                    }
                                Text("Tab 5")
                                    .tabItem {
                                        Text("")
                                    }
                                Text("Tab 6")
                                    .tabItem {
                                        Text("")
                                    }
                                Text("Tab 7")
                                    .tabItem {
                                        Text("")
                                    }
                                Text("Tab 8")
                                    .tabItem {
                                        Text("")
                                    }
                            }
                            Text("Tab 9")
                                .tabItem {
                                    Text("")
                                }
                        }
                    }
                }
                """
            )
        ]
    }
}
