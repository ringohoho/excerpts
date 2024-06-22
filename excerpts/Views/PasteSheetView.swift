//
//  PasteSheetView.swift
//  excerpts
//
//  Created by Richard on 2023/9/13.
//

import SwiftUI

struct PasteSheetView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var excerpt: ExcerptForEdit

    @AppStorage(UserDefaultsKeys.pasteSource)
    private var pasteSource: PasteSource = .defaultValue

    @State private var pasteContent = ""
    @FocusState private var focused: Bool

    @State private var showBadPasteAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("C_PASTE_SOURCE", selection: self.$pasteSource) {
                        ForEach(PasteSource.allCases, id: \.rawValue) { source in
                            Text(source.displayName).tag(source)
                        }
                    }
                }
                Section("C_PASTE_CONTENT") {
                    TextField("PASTE_VIEW_CONTENT_PLACEHOLDER", text: self.$pasteContent, axis: .vertical)
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
                        if self.pasteSource.parser.parse(self.pasteContent, excerpt: &self.excerpt) {
                            self.dismiss()
                        } else {
                            self.showBadPasteAlert = true
                        }
                    }
                    .disabled(self.pasteContent.isEmpty)
                }
            }
            .alert("PASTE_VIEW_ALRT_INVALID_PASTE_CONTENT_FROM \(self.pasteSource.displayName)", isPresented: self.$showBadPasteAlert) {
                Button("A_OK", role: .cancel) {}
            }
            .navigationTitle("PASTE_VIEW_TITLE")
            .navigationBarTitleDisplayMode(.inline)
        }
        .interactiveDismissDisabled()
    }
}

// #Preview("Paste") {
//    struct PreviewView: View {
//        @State var excerpt: Excerpt = .init(.general, title: "", author: "", content: "")
//        var body: some View {
//            PasteSheetView(excerpt: self.$excerpt)
//        }
//    }
//    return PreviewView()
// }
