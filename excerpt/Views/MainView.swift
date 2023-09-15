//
//  SimpleMainView.swift
//  excerpt
//
//  Created by Richard on 2023/9/11.
//

import SwiftUI

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
    @State private var isPoem: Bool = false

    enum ExcerptFormField {
        case content
        case book
        case author
    }

    @FocusState private var focusedFormField: ExcerptFormField?

    @State private var showShareView = false

    init() {
        _excerpt = State(initialValue: Excerpt(id: UUID(), content: "", book: "", author: ""))
    }

    init(_ initialExcerpt: Excerpt, sharing: Bool = false) {
        _excerpt = State(initialValue: initialExcerpt)
        _showShareView = State(initialValue: sharing)
    }

    func handlePasted() {
        let pasted = self.pasted
        if pasted.isEmpty {
            return
        }
        self.pasted = ""

        if let match = pasted.wholeMatch(of: appleBooksExcerptTplt) {
            self.excerpt.content = String(match.1)
            self.excerpt.book = String(match.2)
            self.excerpt.author = String(match.3)
        } else {
            self.showBadPasteAlert = true
        }
    }

    var body: some View {
        ZStack {
            NavigationStack {
                Form {
                    Section {
                        Button("PASTE_VIEW_TITLE") {
                            self.pasted = ""
                            self.showPasteSheet = true
                            self.focusedFormField = nil
                        }
                        .sheet(isPresented: self.$showPasteSheet, onDismiss: self.handlePasted) {
                            PasteSheetView(pasted: self.$pasted)
                        }
                        .alert("MAIN_VIEW_ALRT_INVALID_APPLE_BOOKS_EXCERPT", isPresented: self.$showBadPasteAlert) {
                            Button("A_OK", role: .cancel) {}
                        }
                    }

                    Section(header: Text("A_CONFIG")) {
                        Toggle(isOn: self.$isPoem) {
                            Text("CONFIG_POETRY_MODE")
                        }
                    }

                    Section(header: Text("C_CONTENT")) {
                        TextField("MAIN_VIEW_FORM_CONTENT_PLACEHOLDER", text: self.$excerpt.content, axis: .vertical)
                            .focused(self.$focusedFormField, equals: .content)
                            .lineLimit(6 ... .max)
                    }
                    Section(header: Text(self.isPoem ? "C_POEM" : "C_BOOK")) {
                        TextField(self.isPoem ? "MAIN_VIEW_FORM_POEM_PLACEHOLDER" : "MAIN_VIEW_FORM_BOOK_PLACEHOLDER", text: self.$excerpt.book, axis: .vertical)
                            .focused(self.$focusedFormField, equals: .book)
                    }
                    Section(header: Text("C_AUTHOR")) {
                        TextField("MAIN_VIEW_FORM_AUTHOR_PLACEHOLDER", text: self.$excerpt.author, axis: .vertical)
                            .focused(self.$focusedFormField, equals: .author)
                    }

                    Section {
                        Button("A_SHARE") {
                            self.showShareView = true
                        }
                        .disabled(self.excerpt.content.isEmpty)
                    }
                }
                .navigationTitle("C_APP_NAME")
                .scrollDismissesKeyboard(.interactively)
            }
            .allowsHitTesting(!self.showShareView)
            // another way to blur: https://stackoverflow.com/a/59111492
            .blur(radius: self.showShareView ? backgroundBlurRadius : 0)
            .overlay(self.showShareView ? Color.gray.opacity(0.1) : Color.clear)
            .animation(.easeInOut(duration: animationDuration), value: self.showShareView)

            if self.showShareView {
                ShareView(isPresented: self.$showShareView, excerpt: self.excerpt, isPoem: self.isPoem)
                    .zIndex(1) // to fix animation: https://sarunw.com/posts/how-to-fix-zstack-transition-animation-in-swiftui/
                    .transition(.shareViewTrans)
            }
        }
        .animation(.easeInOut(duration: animationDuration), value: self.showShareView)
    }
}

#Preview("Empty") {
    MainView()
}

#Preview("With Content") {
    MainView(demoExcerpts[0])
}
