//
//  CardFont.swift
//  excerpt
//
//  Created by Richard on 2023/9/20.
//

import SwiftUI

enum CardFont: Int, CaseIterable {
    case system
    case sourceHanSerif

    static var defaultValue: Self {
        .sourceHanSerif
    }

    var displayName: String {
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
