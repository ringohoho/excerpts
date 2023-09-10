//
//  ExcerptsView.swift
//  excerpts
//
//  Created by Richard on 2023/9/9.
//

import SwiftUI

let excerpts = [
    Excerpt(id: UUID(), content: "数学，正确地看，不仅拥有真，也拥有至高的美。一种冷而严峻的美，一种屹立不摇的美。如雕塑一般，一种不为我们软弱天性所动摇的美。不像绘画或音乐那般，有着富丽堂皇的修饰，然而这是极其纯净的美，只有这个最伟大的艺术才能显示出最严格的完美。", author: "罗素", book: ""),
    Excerpt(id: UUID(), content: "许多人宁愿死，也不愿思考，事实上他们也确实至死都没有思考。", author: "罗素", book: ""),
    Excerpt(id: UUID(), content: "一部分儿童具有思考的习惯，而教育的目的在于铲除他们的这种习惯。", author: "罗素", book: "我的信仰")
]

struct ExcerptsView: View {
    @State private var showNewExcerptSheet = false

    var body: some View {
        List {
            Button(LocalizedStringKey("New Excerpt")) {
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
                        Text(LocalizedStringKey("Open"))
                    }
                    Button(LocalizedStringKey("Edit")) {}
                    Button(LocalizedStringKey("Share")) {}
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
