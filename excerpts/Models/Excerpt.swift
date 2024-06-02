//
//  Excerpt.swift
//  excerpt
//
//  Created by Richard on 2023/9/10.
//

import Foundation

enum ExcerptType: Int, CaseIterable, Hashable, Codable {
    case general = 1010
    case verses = 1015
    case lyrics = 1020

    static let defaultValue = Self.general

    var displayName: String {
        switch self {
        case .general: String(localized: "C_GENERAL_TEXT")
        case .verses: String(localized: "C_VERSES")
        case .lyrics: String(localized: "C_LYRICS")
        }
    }
}

struct Excerpt: Hashable, Codable, Identifiable {
    var id: UUID = .init()
    var type: ExcerptType
    var title: String
    var author: String
    var content: String

    init(_ type: ExcerptType, title: String, author: String, content: String) {
        self.id = UUID()
        self.type = type
        self.title = title
        self.author = author
        self.content = content
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

    func contentLinesTrimmed() -> [String] {
        self.content
            .components(separatedBy: self.type == .general ? "\n" : "\n\n")
            .map { s in s.trimmingCharacters(in: .whitespaces) }
    }
}
