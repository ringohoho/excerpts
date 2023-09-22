//
//  Card.swift
//  excerpt
//
//  Created by Richard on 2023/9/20.
//

import SwiftUI

struct CardOptions {
    let excerpt: Excerpt
    let width: CGFloat
    let font: CardFont
}

protocol Card: View {
    static var displayName: String.LocalizationValue { get }
    static var miniPreview: Image { get }
    static var defaultFont: CardFont { get }

    init(_ options: CardOptions)
}
