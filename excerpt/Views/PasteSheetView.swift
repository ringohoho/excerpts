//
//  PasteSheetView.swift
//  excerpt
//
//  Created by Richard on 2023/9/13.
//

import SwiftUI

private enum PasteSource: Int {
    case appleBooks

    var string: String {
        switch self {
        case .appleBooks: String(localized: "C_PASTE_SOURCE_APPLE_BOOKS")
        }
    }
}

private let appleBooksExcerptTplt = /^“([\S\s]*)”\s*摘录来自\n([^\n]+)\n([^\n]+)\n此材料受版权保护。$/
// TODO: english

struct PasteSheetView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var excerpt: Excerpt

    @State private var pasteSource = PasteSource(rawValue: UserDefaults.standard.integer(forKey: UserDefaultsKeys.initialPasteSource)) ?? .appleBooks
    @State private var pasted = ""
    @FocusState private var focused: Bool

    @State private var showBadPasteAlert = false

    private func handlePasted() -> Bool {
        switch self.pasteSource {
        case .appleBooks:
            if let match = self.pasted.wholeMatch(of: appleBooksExcerptTplt) {
                self.excerpt.content = String(match.1)
                self.excerpt.title = String(match.2)
                self.excerpt.author = String(match.3)
                return true
            } else {
                return false
            }
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("C_PASTE_SOURCE", selection: self.$pasteSource) {
                        Text("C_PASTE_SOURCE_APPLE_BOOKS").tag(PasteSource.appleBooks)
                    }
                    .onChange(of: self.pasteSource) { newValue in
                        UserDefaults.standard.set(newValue.rawValue, forKey: UserDefaultsKeys.initialPasteSource)
                    }
                }
                Section("C_PASTE_CONTENT") {
                    TextField("PASTE_VIEW_CONTENT_PLACEHOLDER", text: self.$pasted, axis: .vertical)
                        .focused(self.$focused)
                        .lineLimit(10 ... .max)
                        .frame(maxHeight: .infinity)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .onAppear {
                self.focused = true
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("A_CANCEL") {
                        self.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("A_DONE") {
                        if self.handlePasted() {
                            self.dismiss()
                        } else {
                            self.showBadPasteAlert = true
                        }
                    }
                    .disabled(self.pasted.isEmpty)
                }
            }
            .alert("PASTE_VIEW_ALRT_INVALID_PASTE_CONTENT_FROM \(self.pasteSource.string)", isPresented: self.$showBadPasteAlert) {
                Button("A_OK", role: .cancel) {}
            }
            .navigationTitle("PASTE_VIEW_TITLE")
            .navigationBarTitleDisplayMode(.inline)
        }
        .interactiveDismissDisabled()
    }
}

#Preview("Paste") {
    struct PreviewView: View {
        @State var excerpt: Excerpt = .init(.general, title: "", author: "", content: "")
        var body: some View {
            PasteSheetView(excerpt: self.$excerpt)
        }
    }
    return PreviewView()
}
