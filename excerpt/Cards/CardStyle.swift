//
//  CardStyle.swift
//  excerpt
//
//  Created by Richard on 2023/9/20.
//

import SwiftUI

enum CardStyle: Int, CaseIterable {
    case classic = 1010
    case bold = 1015

    static let defaultValue = Self.classic

    var displayName: String {
        switch self {
        case .classic: String(localized: ClassicCard.displayName)
        case .bold: String(localized: BoldCard.displayName)
        }
    }

    var miniPreview: Image {
        switch self {
        case .classic: ClassicCard.miniPreview
        case .bold: BoldCard.miniPreview
        }
    }

    var defaultFont: CardFont {
        switch self {
        case .classic: ClassicCard.defaultFont
        case .bold: BoldCard.defaultFont
        }
    }

    @ViewBuilder
    func create(_ options: CardOptions) -> some View {
        switch self {
        case .classic: ClassicCard(options)
        case .bold: BoldCard(options)
        }
    }
}
