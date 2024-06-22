//
//  HistoryView.swift
//  excerpts
//
//  Created by Richard on 2024/6/21.
//

import SwiftData
import SwiftUI

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Excerpt.createdAt, order: .reverse)
    private var excerpts: [Excerpt]

    @State private var selectedExcerpt: Excerpt? = nil

    @State private var showShareView = false // this is the inner control state
    @Binding private var isSharing: Bool // this is for notifying outside

    init(isSharing: Binding<Bool>) {
        self._isSharing = isSharing
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(self.excerpts, id: \.id) { excerpt in
                    Button {
                        self.selectedExcerpt = excerpt
                        self.showShareView = true
                        print("selected: \(excerpt.id)")
                    } label: {
                        HistoryRow(excerpt: excerpt)
                    }
                    .foregroundStyle(.primary) // show text in normal style/color
                    .tag(excerpt.id)
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        self.modelContext.delete(self.excerpts[index])
                    }
                })
            }
            .navigationTitle("A_HISTORY")
//            .toolbar { EditButton() } // TODO: has some bug
            .fullScreenCover(isPresented: self.$showShareView) {
                let selectedExcerpt = Binding { self.selectedExcerpt! } set: {
                    // this actually doesn't matter, because ShareView won't reassign the value
                    self.selectedExcerpt = $0
                }
                ShareView(isPresented: self.$showShareView, excerpt: selectedExcerpt, mutable: false)
                    .presentationBackground(.clear)
            }
            .onChange(of: self.showShareView) {
                self.isSharing = self.showShareView
            }
        }
    }
}

#Preview {
    var sharing = false
    let binding = Binding { sharing } set: { sharing = $0 }
    return HistoryView(isSharing: binding)
        .modelContainer(MockData.container)
}
