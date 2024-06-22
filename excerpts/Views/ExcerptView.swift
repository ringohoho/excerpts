//
//  ExcerptView.swift
//  excerpts
//
//  Created by Richard on 2023/9/11.
//

import SwiftData
import SwiftUI

struct ExcerptView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var showPasteSheet = false

    @AppStorage(UserDefaultsKeys.excerptType) // save selected excerpt type for the next time
    private var excerptType: ExcerptType = .general

    @State private var excerptForEdit: ExcerptForEdit
    @State private var excerptSaved: Excerpt
    @State private var excerptIsSaved = false
    @State private var showShareView: Bool

    private enum ExcerptFormField {
        case title
        case author
        case content
    }

    @FocusState private var focusedFormField: ExcerptFormField?

    init() {
        self.init(ExcerptForEdit(), sharing: false)
    }

    init(_ initialExcerpt: Excerpt, sharing: Bool = false) {
        self.init(ExcerptForEdit(initialExcerpt), sharing: sharing)
    }

    init(_ initialExcerpt: ExcerptForEdit, sharing: Bool = false) {
        self._excerptForEdit = State(initialValue: initialExcerpt)
        self._excerptSaved = State(initialValue: Excerpt(.general, initialExcerpt)) // the initial value doesn't matter
        self._showShareView = State(initialValue: sharing)
    }

    func saveExcerpt() {
        if self.excerptIsSaved {
            // update the saved excerpt
            self.excerptSaved.updateWith(self.excerptType, self.excerptForEdit)
            print("update: \(self.excerptSaved.persistentModelID.id)")
        } else {
            // create a new excerpt record
            self.excerptSaved = Excerpt(self.excerptType, self.excerptForEdit)
            self.excerptIsSaved = true
            print("save: \(self.excerptSaved.persistentModelID.id)")
        }
    }

    func resetExcerpt() {
        self.excerptIsSaved = false
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
                        TextField("MAIN_VIEW_FORM_TITLE_PLACEHOLDER", text: self.$excerptForEdit.title, axis: .horizontal)
                            .focused(self.$focusedFormField, equals: .title)
                            .submitLabel(.next)
                            .onSubmit {
                                self.focusedFormField = .author
                            }
                    }
                    Section("C_AUTHOR") {
                        TextField("MAIN_VIEW_FORM_AUTHOR_PLACEHOLDER", text: self.$excerptForEdit.author, axis: .horizontal)
                            .focused(self.$focusedFormField, equals: .author)
                            .submitLabel(.next)
                            .onSubmit {
                                self.focusedFormField = .content
                            }
                    }
                    Section("C_CONTENT") {
                        TextField("MAIN_VIEW_FORM_CONTENT_PLACEHOLDER", text: self.$excerptForEdit.content, axis: .vertical)
                            .focused(self.$focusedFormField, equals: .content)
                            .lineLimit(6 ... .max)
                    }

                    Section {
                        Button("A_SHARE") {
                            self.saveExcerpt()
                            self.showShareView = true
                        }
                        .disabled(self.excerptForEdit.content.isEmpty)

                        // TODO: ask user to confirm
                        Button("C_CLEAR_ALL") {
                            self.excerptForEdit = ExcerptForEdit()
                            self.resetExcerpt()
                        }
                        .disabled(self.excerptForEdit.isEmpty)

                        Button("C_CLEAR_CONTENT") {
                            self.excerptForEdit.content = ""
                            self.resetExcerpt()
                        }
                        .disabled(self.excerptForEdit.content.isEmpty)
                    }
                }
                .scrollDismissesKeyboard(.interactively)
                .navigationTitle("MAIN_VIEW_TITLE")
                .sheet(isPresented: self.$showPasteSheet) {
                    PasteSheetView(excerpt: self.$excerptForEdit)
                }
            }
            .allowsHitTesting(!self.showShareView)
            // another way to blur: https://stackoverflow.com/a/59111492
            .blur(radius: self.showShareView ? 20 : 0)
            .overlay(self.showShareView ? Color.gray.opacity(0.2) : Color.clear)
            .animation(.easeInOut(duration: animationDuration), value: self.showShareView)

            if self.showShareView {
                ShareView(isPresented: self.$showShareView, excerpt: self.$excerptSaved)
                    .zIndex(1) // to fix animation: https://sarunw.com/posts/how-to-fix-zstack-transition-animation-in-swiftui/
                    .transition(.shareViewTrans)
                    .toolbar(.hidden, for: .tabBar) // TODO: move ShareView to top-level
            }
        }
        .animation(.easeInOut(duration: animationDuration), value: self.showShareView)
    }
}

#Preview("Empty") {
    ExcerptView()
        .environment(\.locale, .init(identifier: "zh-Hans"))
        .modelContainer(MockData.container)
}

#Preview("Non-empty English") {
    TabView {
        ExcerptView(demoExcerpts[0])
    }
    .environment(\.locale, .init(identifier: "en"))
    .modelContainer(MockData.container)
}
