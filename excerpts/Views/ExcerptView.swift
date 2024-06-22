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
    @State private var excerpt: Excerpt
    @State private var excerptIsSaved = false

    @State private var showShareView = false // this is the inner control state
    @Binding private var isSharing: Bool // this is for notifying outside

    private enum ExcerptFormField {
        case title
        case author
        case content
    }

    @FocusState private var focusedFormField: ExcerptFormField?

    init(isSharing: Binding<Bool>) {
        self.init(ExcerptForEdit(), isSharing: isSharing)
    }

    init(_ initialExcerpt: Excerpt, isSharing: Binding<Bool>) {
        self.init(ExcerptForEdit(initialExcerpt), isSharing: isSharing)
    }

    init(_ initialExcerpt: ExcerptForEdit, isSharing: Binding<Bool>) {
        self._excerptForEdit = State(initialValue: initialExcerpt)
        self._excerpt = State(initialValue: Excerpt(.general, initialExcerpt)) // the initial value doesn't matter
        self._isSharing = isSharing
    }

    var body: some View {
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
                        if self.excerptIsSaved {
                            // update the saved excerpt
                            self.excerpt.updateWith(self.excerptType, self.excerptForEdit)
                            print("updated: \(self.excerpt.id)")
                        } else {
                            // create a new excerpt record
                            self.excerpt = Excerpt(self.excerptType, self.excerptForEdit)
                            print("created: \(self.excerpt.id)")
                            // but don't save it for now, instead, save it after successfully rendering the image
                        }

                        self.showShareView = true
                    }
                    .onChange(of: self.excerpt.sharedImageData) {
                        if !self.excerptIsSaved {
                            self.modelContext.insert(self.excerpt)
                            self.excerptIsSaved = true
                            print("saved: \(self.excerpt.id)")
                        }
                    }
                    .disabled(self.excerptForEdit.content.isEmpty)

                    // TODO: ask user to confirm
                    Button("C_CLEAR_ALL") {
                        self.excerptForEdit = ExcerptForEdit()
                        self.excerptIsSaved = false
                    }
                    .disabled(self.excerptForEdit.isEmpty)

                    Button("C_CLEAR_CONTENT") {
                        self.excerptForEdit.content = ""
                        self.excerptIsSaved = false
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
        .animation(.easeInOut(duration: animationDuration), value: showShareView)
        .fullScreenCover(isPresented: $showShareView) {
            ShareView(isPresented: self.$showShareView, excerpt: self.$excerpt, mutable: true)
                .presentationBackground(.clear)
        }
        .onChange(of: showShareView) {
            self.isSharing = self.showShareView
        }
    }
}

#Preview("Empty") {
    var sharing = false
    let binding = Binding { sharing } set: { sharing = $0 }
    return ExcerptView(isSharing: binding)
        .environment(\.locale, .init(identifier: "zh-Hans"))
        .modelContainer(MockData.container)
}

#Preview("Non-empty English") {
    var sharing = false
    let binding = Binding { sharing } set: { sharing = $0 }
    return TabView {
        ExcerptView(demoExcerpts[0], isSharing: binding)
    }
    .environment(\.locale, .init(identifier: "en"))
    .modelContainer(MockData.container)
}
