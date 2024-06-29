//
//  Card.swift
//  excerpts
//
//  Created by Richard on 2023/9/20.
//

import SwiftUI

struct CardMeta {
    let displayName: String.LocalizationValue
    let miniPreview: Image
    let defaultFont: CardFont
}

struct CardOptions {
    let excerpt: Excerpt
    let width: CGFloat
    let font: CardFont
}

protocol Card: View {
    static var meta: CardMeta { get }

    init(_ options: CardOptions)
}

enum CardConsts {
    static let cardContainerPadding: CGFloat = 12
    static let maxCardContainerWidth: CGFloat = 400

    static func cardWidth(_ geoWidth: CGFloat) -> CGFloat {
        min(geoWidth, Self.maxCardContainerWidth) - Self.cardContainerPadding * 2
    }
}
