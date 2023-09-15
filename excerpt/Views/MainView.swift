//
//  MainView.swift
//  excerpt
//
//  Created by Richard on 2023/9/11.
//

import SwiftUI

let keyLastExcerptType = "lastExcerptType"

let animationDuration: CGFloat = 0.2
let backgroundBlurRadius: CGFloat = 20

let appleBooksExcerptTplt = /^“([\S\s]*)”\s*摘录来自\n([^\n]+)\n([^\n]+)\n此材料受版权保护。$/
// TODO: english

extension AnyTransition {
    static var shareViewTrans: AnyTransition {
        AnyTransition.offset(y: 60).combined(with: .opacity)
    }
}

struct MainView: View {
    @State private var showPasteSheet = false
    @State private var pasted = ""
    @State private var showBadPasteAlert = false

    @State private var excerpt: Excerpt
    @State private var excerptType: ExcerptType
    @State private var showShareView: Bool

    enum ExcerptFormField {
        case title
        case author
        case content
    }

    @FocusState private var focusedFormField: ExcerptFormField?

    init() {
        self.init(Excerpt.empty(), ExcerptType(rawValue: UserDefaults.standard.integer(forKey: keyLastExcerptType)) ?? .paragraphs, sharing: false)
    }

    init(_ initialExcerpt: Excerpt, _ initialExcerptType: ExcerptType, sharing: Bool = false) {
        self._excerpt = State(initialValue: initialExcerpt)
        self._excerptType = State(initialValue: initialExcerptType)
        self._showShareView = State(initialValue: sharing)
    }

    func handlePasted() {
        let pasted = self.pasted
        if pasted.isEmpty {
            return
        }
        self.pasted = ""

        if let match = pasted.wholeMatch(of: appleBooksExcerptTplt) {
            self.excerpt.content = String(match.1)
            self.excerpt.title = String(match.2)
            self.excerpt.author = String(match.3)
        } else {
            self.showBadPasteAlert = true
        }
    }

    var body: some View {
        ZStack {
            NavigationStack {
                Form {
                    Section(header: Text("A_CONFIG")) {
                        Picker("C_EXCERPT_TYPE", selection: self.$excerptType) {
                            Text("C_PARAGRAPHS").tag(ExcerptType.paragraphs)
                            Text("C_VERSES").tag(ExcerptType.verses)
                            Text("C_LYRICS").tag(ExcerptType.lyrics)
                        }
                        .onChange(of: self.excerptType) { newValue in
                            UserDefaults.standard.set(newValue.rawValue, forKey: keyLastExcerptType)
                        }
                    }

                    Section(header: Text("C_TITLE")) {
                        TextField("MAIN_VIEW_FORM_TITLE_PLACEHOLDER", text: self.$excerpt.title, axis: .vertical)
                            .focused(self.$focusedFormField, equals: .title)
                    }
                    Section(header: Text("C_AUTHOR")) {
                        TextField("MAIN_VIEW_FORM_AUTHOR_PLACEHOLDER", text: self.$excerpt.author, axis: .vertical)
                            .focused(self.$focusedFormField, equals: .author)
                    }
                    Section(header: Text("C_CONTENT")) {
                        TextField("MAIN_VIEW_FORM_CONTENT_PLACEHOLDER", text: self.$excerpt.content, axis: .vertical)
                            .focused(self.$focusedFormField, equals: .content)
                            .lineLimit(6 ... .max)
                    }

                    Section {
                        Button("A_SHARE") {
                            self.showShareView = true
                        }
                        .disabled(self.excerpt.content.isEmpty)
                    }
                }
                .scrollDismissesKeyboard(.interactively)
                .navigationTitle("C_APP_NAME")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button("PASTE_VIEW_TITLE") {
                                self.pasted = ""
                                self.showPasteSheet = true
                                self.focusedFormField = nil
                            }
                        } label: {
                            Image(systemName: "doc.on.clipboard")
                        }
                    }
                }
                .sheet(isPresented: self.$showPasteSheet, onDismiss: self.handlePasted) {
                    PasteSheetView(pasted: self.$pasted)
                }
                .alert("MAIN_VIEW_ALRT_INVALID_APPLE_BOOKS_EXCERPT", isPresented: self.$showBadPasteAlert) {
                    Button("A_OK", role: .cancel) {}
                }
            }
            .allowsHitTesting(!self.showShareView)
            // another way to blur: https://stackoverflow.com/a/59111492
            .blur(radius: self.showShareView ? backgroundBlurRadius : 0)
            .overlay(self.showShareView ? Color.gray.opacity(0.1) : Color.clear)
            .animation(.easeInOut(duration: animationDuration), value: self.showShareView)

            if self.showShareView {
                ShareView(isPresented: self.$showShareView, excerpt: self.excerpt, excerptType: self.excerptType)
                    .zIndex(1) // to fix animation: https://sarunw.com/posts/how-to-fix-zstack-transition-animation-in-swiftui/
                    .transition(.shareViewTrans)
            }
        }
        .animation(.easeInOut(duration: animationDuration), value: self.showShareView)
    }
}

#Preview("Empty") {
    MainView()
        .environment(\.locale, .init(identifier: "zh-Hans"))
}

#Preview("With Content") {
    MainView(demoExcerpts[0], .paragraphs)
        .environment(\.locale, .init(identifier: "en"))
}
