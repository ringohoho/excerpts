//
//  SimpleMainView.swift
//  excerpts
//
//  Created by Richard on 2023/9/11.
//

import SwiftUI

let booksExcerptTplt = /^“([\S\s]*)”\s*摘录来自\n([^\n]+)\n([^\n]+)\n此材料受版权保护。$/

struct PasteSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var pasted: String

    var body: some View {
        NavigationStack {
            Form {
                TextField(LocalizedStringKey("Please paste excerpt here."), text: self.$pasted, axis: .vertical)
                    .lineLimit(10 ... .max)
                    .frame(maxHeight: .infinity)
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle(LocalizedStringKey("Paste from Books"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizedStringKey("Cancel")) {
                        self.pasted = ""
                        self.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(LocalizedStringKey("Done")) {
                        self.dismiss()
                    }
                    .disabled(self.pasted.isEmpty)
                }
            }
        }
        .interactiveDismissDisabled()
    }
}

struct SimpleMainView: View {
    @State private var showPasteSheet = false
    @State private var pasted = ""
    @State private var showBadPasteAlert = false

    @State private var content = ""
    @State private var book = ""
    @State private var author = ""

    func handlePasted() {
        let pasted = self.pasted
        if pasted.isEmpty {
            return
        }
        self.pasted = ""

        print("Pasted: \(pasted)")

        if let match = pasted.wholeMatch(of: booksExcerptTplt) {
            self.content = String(match.1)
            self.book = String(match.2)
            self.author = String(match.3)
        } else {
            self.showBadPasteAlert = true
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Button(LocalizedStringKey("Paste from Books")) {
                    self.pasted = ""
                    self.showPasteSheet.toggle()
                }
                .sheet(isPresented: self.$showPasteSheet, onDismiss: self.handlePasted) {
                    PasteSheetView(pasted: self.$pasted)
                }
                .alert(LocalizedStringKey("Not a valid excerpt from Books."), isPresented: self.$showBadPasteAlert) {
                    Button(LocalizedStringKey("OK"), role: .cancel) {}
                }

                Section(header: Text(LocalizedStringKey("Content"))) {
                    TextField(LocalizedStringKey("Please enter excerpt content here."), text: self.$content, axis: .vertical)
                        .lineLimit(6 ... .max)
                }
                Section(header: Text(LocalizedStringKey("Book"))) {
                    TextField(LocalizedStringKey("Please enter the book name here."), text: self.$book, axis: .vertical)
                }
                Section(header: Text(LocalizedStringKey("Author"))) {
                    TextField(LocalizedStringKey("Please enter the author name here."), text: self.$author, axis: .vertical)
                }

                Button(LocalizedStringKey("Share")) {}
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle(LocalizedStringKey("Excerpt"))
        }
    }
}

#Preview {
    SimpleMainView()
}
