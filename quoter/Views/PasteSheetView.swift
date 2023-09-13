//
//  PasteSheetView.swift
//  quoter
//
//  Created by Richard on 2023/9/13.
//

import SwiftUI

struct PasteSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var pasted: String

    @FocusState private var focused: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("PASTE_VIEW_TEXT_PLACEHOLDER", text: self.$pasted, axis: .vertical)
                        .focused(self.$focused)
                        .lineLimit(10 ... .max)
                        .frame(maxHeight: .infinity)
                }
            }
            .navigationTitle("PASTE_VIEW_TITLE")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("A_CANCEL") {
                        self.pasted = ""
                        self.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("A_DONE") {
                        self.dismiss()
                    }
                    .disabled(self.pasted.isEmpty)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .onAppear {
                self.focused = true
            }
        }
        .interactiveDismissDisabled()
    }
}

#Preview("Paste") {
    struct PreviewView: View {
        @State var pasted = ""
        var body: some View {
            PasteSheetView(pasted: self.$pasted)
        }
    }
    return PreviewView()
}
