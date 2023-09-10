//
//  ExcerptDetailView.swift
//  excerpts
//
//  Created by Richard on 2023/9/9.
//

import SwiftUI

struct ExcerptDetailView: View {
    var excerpt: Excerpt

    init(_ excerpt: Excerpt) {
        self.excerpt = excerpt
    }

    var body: some View {
        VStack {
            Text(self.excerpt.content)
                .font(.custom("SourceHanSerifSC-Regular", size: 18))
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(LocalizedStringKey("Share")) {}
            }
        }
    }
}

#Preview {
    ExcerptDetailView(excerpts[0])
}
