//
//  AppleBooksPasteParser.swift
//  excerpts
//
//  Created by Richard on 2023/9/20.
//

import Foundation

private let appleBooksExcerptTplts: [Regex] = [
    /^“([\S\s]*)”\s*摘录来自\n([^\n]+)\n([^\n]+)(?:\n[^\n]+)?\n[^\n]*材料[^\n]*版权保护。$/,
    /^“([\S\s]*)”\s*Excerpt From\n([^\n]+)\n([^\n]+)(?:\n[^\n]+)?\n[^\n]*material[^\n]*protected by copyright\.$/,
]

struct AppleBooksPasteParser: PasteParser {
    func parse(_ content: String, excerpt: inout Excerpt) -> Bool {
        for tplt in appleBooksExcerptTplts {
            if let match = content.wholeMatch(of: tplt) {
                excerpt.content = String(match.1)
                excerpt.title = String(match.2)
                excerpt.author = String(match.3)
                return true
            }
        }
        return false
    }
}
