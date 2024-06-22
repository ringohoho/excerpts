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

    @Query(sort: \Excerpt.updatedAt, order: .reverse)
    private var excerpts: [Excerpt]

    var body: some View {
        NavigationStack {
            List {
                ForEach(self.excerpts, id: \.id) { excerpt in
                    HistoryRow(excerpt: excerpt)
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        self.modelContext.delete(self.excerpts[index])
                    }
                })
            }
            .navigationTitle("A_HISTORY")
            .toolbar { EditButton() }
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(MockData.container)
}
