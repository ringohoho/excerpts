//
//  PasteParser.swift
//  excerpts
//
//  Created by Richard on 2023/9/20.
//

import Foundation

protocol PasteParser {
    func parse(_ content: String, excerpt: inout ExcerptForEdit) -> Bool
}
