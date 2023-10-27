//
//  SidebarInitiallyVisibleRule+Examples.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore

extension SidebarInitiallyVisibleRule {

    static var nonTriggeringExamples: [Example] {
        [
            Example(
                """
                struct SideBarExample: View {
                    var body: some View {
                        NavigationSplitView(columnVisibility: .all) {
                            Text("content")
                        } content: {
                            Text("content")
                        } detail: {
                            Text("detail")
                        }
                    }
                }
                """
            ),
            Example(
                """
                struct SideBarExample: View {
                    var body: some View {
                        NavigationSplitView(columnVisibility: .automatic) {
                            Text("content")
                        } content: {
                            Text("content")
                        } detail: {
                            Text("detail")
                        }
                    }
                }
                """
            ),
            Example(
                """
                struct SideBarExample: View {
                    var body: some View {
                        NavigationSplitView(columnVisibility: .doubleColumn) {
                            Text("content")
                        } detail: {
                            Text("detail")
                        }
                    }
                }
                """
            ),
            Example(
                """
                struct SideBarExample: View {
                    var body: some View {
                        NavigationSplitView {
                            Text("content")
                        } detail: {
                            Text("detail")
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
                struct SideBarExample: View {
                    @State
                    private var visibility = NavigationSplitViewVisibility.detailOnly
                    var body: some View {
                        NavigationSplitView(columnVisibility: ↓$visibility) {
                            Text("sidebar")
                        } content: {
                            Text("content")
                        } detail: {
                            Text("detail")
                        }
                    }
                }
                """
            ),
            Example(
                """
                struct SideBarExample: View {
                    var body: some View {
                        NavigationSplitView(columnVisibility: ↓.detailOnly) {
                            Text("sidebar")
                        } content: {
                            Text("content")
                        } detail: {
                            Text("detail")
                        }
                    }
                }
                """
            ),
            Example(
                """
                struct SideBarExample: View {
                    var body: some View {
                        NavigationSplitView(
                            columnVisibility: ↓NavigationSplitViewVisibility.detailOnly
                        ) {
                            Text("sidebar")
                        } content: {
                            Text("content")
                        } detail: {
                            Text("detail")
                        }
                    }
                }
                """
            ),
            Example(
                """
                struct SideBarExample: View {
                    var body: some View {
                        NavigationSplitView(columnVisibility: ↓.doubleColumn) {
                            Text("sidebar")
                        } content: {
                            Text("content")
                        } detail: {
                            Text("detail")
                        }
                    }
                }
                """
            ),
            Example(
                """
                struct SideBarExample: View {
                    var body: some View {
                        NavigationSplitView(
                            columnVisibility: ↓NavigationSplitViewVisibility.doubleColumn
                        ) {
                            Text("sidebar")
                        } content: {
                            Text("content")
                        } detail: {
                            Text("detail")
                        }
                    }
                }
                """
            )
        ]
    }
}
