//
//  CardStyle.swift
//  excerpt
//
//  Created by Richard on 2023/9/20.
//

import SwiftUI

enum CardStyle: Int, CaseIterable {
    case classic = 1010

    static let defaultValue = Self.classic

    var displayName: String {
        switch self {
        case .classic: String(localized: "C_STYLE_CLASSIC")
        }
    }

    @ViewBuilder
    func create(_ options: CardOptions) -> some Card {
        switch self {
        case .classic:
            ClassicCard(options)
        }
    }
}
