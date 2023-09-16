//
//  Excerpt.swift
//  excerpt
//
//  Created by Richard on 2023/9/10.
//

import Foundation

let demoExcerpts = [
    Excerpt(title: "", author: "罗素", content: "数学，正确地看，不仅拥有真，也拥有至高的美。一种冷而严峻的美，一种屹立不摇的美。如雕塑一般，一种不为我们软弱天性所动摇的美。不像绘画或音乐那般，有着富丽堂皇的修饰，然而这是极其纯净的美，只有这个最伟大的艺术才能显示出最严格的完美。"),
    Excerpt(title: "", author: "罗素", content: "许多人宁愿死，也不愿思考，事实上他们也确实至死都没有思考。"),
    Excerpt(title: "我的信仰", author: "罗素", content: "一部分儿童具有思考的习惯，而教育的目的在于铲除他们的这种习惯。")
]

struct Excerpt: Hashable, Codable, Identifiable {
    var id: UUID = .init()
    var title: String
    var author: String
    var content: String

    static func empty() -> Excerpt {
        Excerpt(id: UUID(), title: "", author: "", content: "")
    }

    var titleTrimmed: String {
        self.title.trimmingCharacters(in: .whitespacesAndNewlines).replacing("\n", with: " ")
    }

    var authorTrimmed: String {
        self.author.trimmingCharacters(in: .whitespacesAndNewlines).replacing("\n", with: " ")
    }

    var contentTrimmed: String {
        self.content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
