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
    @EnvironmentObject private var trash: Trash

    @Query(sort: \Excerpt.updatedAt, order: .reverse)
    private var excerpts: [Excerpt]

    @State private var selectedExcerpt: Excerpt? = nil

    var body: some View {
        NavigationStack {
            List {
                ForEach(self.excerpts, id: \.id) { excerpt in
                    Button {
                        self.selectedExcerpt = excerpt
                        print("selected: \(excerpt.id)")
                    } label: {
                        HistoryRow(excerpt: excerpt)
                    }
                    .foregroundStyle(.primary) // show text in normal style/color
                    .tag(excerpt.id)
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        let excerpt = self.excerpts[index]
                        self.trash.recentDeleted = excerpt.id
                        self.modelContext.delete(excerpt)
                    }
                })
            }
            .navigationTitle("A_HISTORY")
//            .toolbar { EditButton() } // TODO: has some bug
            .fullScreenCover(item: self.$selectedExcerpt) { excerpt in
                let binding = Binding { excerpt } set: {
                    let _ = $0 // doesn't matter
                }
                ShareView(excerpt: binding, mutable: false)
                    .presentationBackground(.ultraThinMaterial)
            }
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(MockData.container)
        .environmentObject(Trash())
}
