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
            Spacer()
        }
    }
}

#Preview {
    ExcerptDetailView(excerpts[0])
}
