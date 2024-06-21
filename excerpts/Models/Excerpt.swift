//
//  Excerpt.swift
//  excerpts
//
//  Created by Richard on 2023/9/10.
//

import Foundation
import SwiftData

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

@Model
final class Excerpt {
    var id = UUID()
    var type = ExcerptType.general
    var title = ""
    var author = ""
    var content = ""

    init(_ type: ExcerptType) {
        self.id = UUID()
        self.type = type
    }

    init(_ type: ExcerptType, title: String, author: String, content: String) {
        self.id = UUID()
        self.type = type
        self.title = title
        self.author = author
        self.content = content
    }

    var isEmpty: Bool {
        self.title.isEmpty && self.author.isEmpty && self.content.isEmpty
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
