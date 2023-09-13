//
//  ExcerptsView.swift
//  excerpt
//
//  Created by Richard on 2023/9/9.
//

import SwiftUI

struct ExcerptsView: View {
    @State private var showNewExcerptSheet = false

    var body: some View {
        List {
            Button("New Excerpt") {
                self.showNewExcerptSheet = true
            }
            .sheet(isPresented: $showNewExcerptSheet) {
                NewExcerptSheetView()
            }

            ForEach(excerpts) { excerpt in
                NavigationLink(value: excerpt) {
                    Text(excerpt.content)
                        .lineLimit(3)
                        .truncationMode(.tail)
                }
                .contextMenu {
                    NavigationLink(value: excerpt) {
                        Text("Open")
                    }
                    Button("Edit") {}
                    Button("Share") {}
                }
            }
        }
        .navigationDestination(for: Excerpt.self) { excerpt in
            ExcerptDetailView(excerpt)
                //                .navigationTitle(excerpt.content.prefix(8) + "...")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ExcerptsView()
}
