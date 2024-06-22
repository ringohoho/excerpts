//
//  HistoryRow.swift
//  excerpts
//
//  Created by Richard on 2024/6/22.
//

import SwiftUI

struct HistoryRow: View {
    var excerpt: Excerpt

    var body: some View {
        VStack(spacing: 8) {
            Text(self.excerpt.contentLinesTrimmed().joined(separator: "\n"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(4, reservesSpace: false)

            let meta = [self.excerpt.authorTrimmed, self.excerpt.titleTrimmed]
                .filter { !$0.isEmpty }
                .joined(separator: String(localized: "HISTORY_ROW_META_SEP"))
            if !meta.isEmpty {
                Text("CARD_VIEW_AUTHOR_TPLT \(meta)")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    HistoryRow(excerpt: demoExcerpts[0])
}
