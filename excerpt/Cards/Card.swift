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
    init(_ options: CardOptions)
}
