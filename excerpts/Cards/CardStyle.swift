//
//  CardStyle.swift
//  excerpts
//
//  Created by Richard on 2023/9/20.
//

import SwiftUI

enum CardStyle: Int, CaseIterable {
    case classic = 1010
    case minimal = 1013
    case bold = 1015

    static let defaultValue = Self.classic

    var meta: CardMeta {
        switch self {
        case .classic: ClassicCard.meta
        case .minimal: MinimalCard.meta
        case .bold: BoldCard.meta
        }
    }

    @ViewBuilder
    func create(_ options: CardOptions) -> some View {
        switch self {
        case .classic: ClassicCard(options)
        case .minimal: MinimalCard(options)
        case .bold: BoldCard(options)
        }
    }
}
