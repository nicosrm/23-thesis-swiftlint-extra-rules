//
//  FeedbackSoundRule+Examples.swift
//  SwiftLintExtraRules
//
//  Created by nicosrm
//

import SwiftLintCore

extension FeedbackSoundRule {

    static var nonTriggeringExamples: [Example] {
        [
            Example(
                """
                struct MyView: View {
                    var body: some View {
                        Text("Hello World")
                            .onTapGesture {
                                AudioServicesPlaySystemSound(1104)
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
                            .onTapGesture(
                                count: 1,
                                perform: {
                                    AudioServicesPlaySystemSound(1104)
                                }
                            )
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var url = URL(string: "example.com")!
                    var body: some View {
                        Text("Hello World")
                            .onTapGesture {
                                do {
                                    let sound = try AVAudioPlayer(contentsOf: url)
                                    sound.play()
                                } catch {}
                            }
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    var url = URL(string: "example.com")!
                    var body: some View {
                        Text("Hello World")
                            .onTapGesture(count: 1) {
                                do {
                                    let sound = try AVAudioPlayer(contentsOf: url)
                                    sound.play()
                                } catch {}
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
                        ↓Text("Hello World")
                            .onTapGesture {
                                print("Hello")
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
                            .onTapGesture(count: 1) {
                                print("Hello")
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
                            .onTapGesture(
                                count: 1,
                                perform: {
                                    print("Hello")
                                }
                            )
                    }
                }
                """
            ),
            Example(
                """
                struct MyView: View {
                    private let action: () -> ()
                    var body: some View {
                        ↓Text("Hello World")
                            .onTapGesture(
                                count: 1,
                                perform: action
                            )
                    }
                }
                """
            )
        ]
    }
}
