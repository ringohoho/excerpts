//
//  CardOptions.swift
//  excerpt
//
//  Created by Richard on 2023/9/20.
//

import SwiftUI

enum CardFont: Int, CaseIterable {
    case system
    case sourceHanSerif

    var string: String {
        switch self {
        case .system: String(localized: "C_FONT_SYSTEM")
        case .sourceHanSerif: String(localized: "C_FONT_SOURCE_HAN_SERIF")
        }
    }

    func font(size: CGFloat) -> Font {
        switch self {
        case .system: .system(size: size)
        case .sourceHanSerif: .custom("SourceHanSerifSC-Regular", size: size)
        }
    }
}

struct CardOptions {
    let excerpt: Excerpt
    let width: CGFloat
    let font: CardFont
}
