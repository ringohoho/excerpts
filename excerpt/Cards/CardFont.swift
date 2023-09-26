//
//  CardFont.swift
//  excerpt
//
//  Created by Richard on 2023/9/20.
//

import SwiftUI

enum CardFont: Int, CaseIterable {
    case system = 1010
    case sourceHanSerif = 1015

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

    func charWidth(size: CGFloat) -> CGFloat {
        switch self {
        case .system: size + 0.325 // FIXME: seems a little bit dirty
        case .sourceHanSerif: size
        }
    }
}
