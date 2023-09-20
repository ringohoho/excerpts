//
//  AppleBooksPasteParser.swift
//  excerpt
//
//  Created by Richard on 2023/9/20.
//

import Foundation

private let appleBooksExcerptTplt = /^“([\S\s]*)”\s*摘录来自\n([^\n]+)\n([^\n]+)(?:\n[^\n]+)?\n此材料(?:可能)?受版权保护。$/
// TODO: english

struct AppleBooksPasteParser: PasteParser {
    func parse(_ content: String, excerpt: inout Excerpt) -> Bool {
        if let match = content.wholeMatch(of: appleBooksExcerptTplt) {
            excerpt.content = String(match.1)
            excerpt.title = String(match.2)
            excerpt.author = String(match.3)
            return true
        } else {
            return false
        }
    }
}
