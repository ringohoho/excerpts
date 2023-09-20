//
//  PasteSource.swift
//  excerpt
//
//  Created by Richard on 2023/9/20.
//

import Foundation

enum PasteSource: Int, CaseIterable {
    case appleBooks = 1000

    static var defaultValue: Self {
        .appleBooks
    }

    var displayName: String {
        switch self {
        case .appleBooks: String(localized: "C_PASTE_SOURCE_APPLE_BOOKS")
        }
    }

    var parser: any PasteParser {
        switch self {
        case .appleBooks: AppleBooksPasteParser()
        }
    }
}
