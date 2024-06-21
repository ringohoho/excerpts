//
//  MainView.swift
//  excerpts
//
//  Created by Richard on 2023/9/11.
//

import SwiftUI

private let animationDuration: CGFloat = 0.2

private extension AnyTransition {
    static var shareViewTrans: AnyTransition {
        AnyTransition.offset(y: 60).combined(with: .opacity)
    }
}

struct MainView: View {
    @State private var showPasteSheet = false

    @AppStorage(UserDefaultsKeys.excerptType) // save selected excerpt type for the next time
    private var excerptType: ExcerptType = .general

    @State private var excerpt: Excerpt
    @State private var showShareView: Bool

    private enum ExcerptFormField {
        case title
        case author
        case content
    }

    @FocusState private var focusedFormField: ExcerptFormField?

    init() {
        let excerpt = Excerpt(.general)
        self.init(excerpt, sharing: false)
    }

    init(_ initialExcerpt: Excerpt, sharing: Bool = false) {
        self._excerpt = State(initialValue: initialExcerpt)
        self._showShareView = State(initialValue: sharing)
    }

    var body: some View {
        ZStack {
            NavigationStack {
                Form {
                    Section {
                        Button("PASTE_VIEW_TITLE") {
                            self.showPasteSheet = true
                            self.focusedFormField = nil
                        }

                        Picker("C_EXCERPT_TYPE", selection: self.$excerptType) {
                            ForEach(ExcerptType.allCases, id: \.rawValue) { type in
                                Text(type.displayName).tag(type)
                            }
                        }
                    }

                    Section("C_TITLE") {
                        TextField("MAIN_VIEW_FORM_TITLE_PLACEHOLDER", text: self.$excerpt.title, axis: .horizontal)
                            .focused(self.$focusedFormField, equals: .title)
                            .submitLabel(.next)
                            .onSubmit {
                                self.focusedFormField = .author
                            }
                    }
                    Section("C_AUTHOR") {
                        TextField("MAIN_VIEW_FORM_AUTHOR_PLACEHOLDER", text: self.$excerpt.author, axis: .horizontal)
                            .focused(self.$focusedFormField, equals: .author)
                            .submitLabel(.next)
                            .onSubmit {
                                self.focusedFormField = .content
                            }
                    }
                    Section("C_CONTENT") {
                        TextField("MAIN_VIEW_FORM_CONTENT_PLACEHOLDER", text: self.$excerpt.content, axis: .vertical)
                            .focused(self.$focusedFormField, equals: .content)
                            .lineLimit(6 ... .max)
                    }

                    Section {
                        Button("A_SHARE") {
                            self.excerpt.type = self.excerptType
                            self.showShareView = true
                        }
                        .disabled(self.excerpt.content.isEmpty)
                    }

                    Section {
                        Button("A_RESET") {
                            self.excerpt = Excerpt(self.excerptType) // mainly to reset the UUID
                        }
                        .disabled(self.excerpt.isEmpty)
                    }
                }
                .scrollDismissesKeyboard(.interactively)
                .navigationTitle(Bundle.main.displayName)
                .sheet(isPresented: self.$showPasteSheet) {
                    PasteSheetView(excerpt: self.$excerpt)
                }
            }
            .allowsHitTesting(!self.showShareView)
            // another way to blur: https://stackoverflow.com/a/59111492
            .blur(radius: self.showShareView ? 20 : 0)
            .overlay(self.showShareView ? Color.gray.opacity(0.2) : Color.clear)
            .animation(.easeInOut(duration: animationDuration), value: self.showShareView)

            if self.showShareView {
                ShareView(isPresented: self.$showShareView, excerpt: self.excerpt)
                    .zIndex(1) // to fix animation: https://sarunw.com/posts/how-to-fix-zstack-transition-animation-in-swiftui/
                    .transition(.shareViewTrans)
            }
        }
        .animation(.easeInOut(duration: animationDuration), value: showShareView)
    }
}

#Preview("Empty") {
    MainView()
        .environment(\.locale, .init(identifier: "zh-Hans"))
        .modelContainer(MockData.container)
}

#Preview("Non-empty English") {
    MainView(demoExcerpts[0])
        .environment(\.locale, .init(identifier: "en"))
        .modelContainer(MockData.container)
}
