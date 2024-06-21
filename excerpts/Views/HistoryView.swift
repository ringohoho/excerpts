//
//  HistoryView.swift
//  excerpts
//
//  Created by Richard on 2024/6/21.
//

import SwiftUI

struct HistoryView: View {
    @State private var dummy = [
        "西方哲学史",
        "佛学概论",
        "哥德尔、艾舍尔、巴赫"
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(self.dummy, id: \.self) { item in
                    Text(item)
                }
                .onDelete(perform: { indexSet in
                    self.dummy.remove(atOffsets: indexSet)
                })
            }
            .navigationTitle("A_HISTORY")
            .toolbar { EditButton() }
        }
    }
}

#Preview {
    HistoryView()
}
