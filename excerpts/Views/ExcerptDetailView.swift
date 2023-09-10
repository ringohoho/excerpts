//
//  ExcerptDetailView.swift
//  excerpts
//
//  Created by Richard on 2023/9/9.
//

import SwiftUI

struct ExcerptDetailView: View {
    var excerpt: String

    init(_ excerpt: String) {
        self.excerpt = excerpt
    }

    var body: some View {
        VStack {
            Text(self.excerpt)
            Spacer()
        }
    }
}

#Preview {
    ExcerptDetailView("Test")
}
