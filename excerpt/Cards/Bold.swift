//
//  Bold.swift
//  excerpt
//
//  Created by Richard on 2023/9/22.
//

import SwiftUI

private enum C {
    static let colorBg = Color("7C2216")!
    static let colorContent = Color.white
    static let colorWatermark = Color("EEEEEE")!

    static let fontSizeContent: CGFloat = 25
    static let fontSizeFrom: CGFloat = 15
    static let fontSizeWatermark: CGFloat = 10
}

private extension Text {
    func asContent(_ options: CardOptions) -> some View {
        self.font(options.font.font(size: C.fontSizeContent))
            .fontWeight(.bold)
            .foregroundStyle(C.colorContent)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineSpacing(C.fontSizeContent * 0.2)
    }

    func asTitle(_ options: CardOptions) -> some View {
        self.font(options.font.font(size: C.fontSizeFrom))
            .fontWeight(.bold)
            .foregroundStyle(C.colorContent)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    func asAuthor(_ options: CardOptions) -> some View {
        self.font(options.font.font(size: C.fontSizeFrom))
            .foregroundStyle(C.colorContent)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    func inWatermarkSection() -> some View {
        self.font(.system(size: C.fontSizeWatermark))
            .foregroundStyle(C.colorWatermark)
    }
}

struct BoldCard: Card {
    static let meta: CardMeta = .init(
        displayName: "C_STYLE_BOLD",
        miniPreview: .init(systemName: "rectangle.fill"),
        defaultFont: .system
    )

    let options: CardOptions

    init(_ options: CardOptions) {
        self.options = options
    }

    private var excerpt: Excerpt {
        self.options.excerpt
    }

    private var width: CGFloat {
        self.options.width
    }

    private var font: CardFont {
        self.options.font
    }

    private var contentWidth: CGFloat {
        round(self.width - C.fontSizeContent * 2, toNearest: C.fontSizeContent)
    }

    private var contentPadding: CGFloat {
        (self.width - self.contentWidth) / 2
    }

    private var fromVertPadding: CGFloat {
        self.contentPadding * 0.8
    }

    var body: some View {
        VStack {
            VStack(spacing: C.fontSizeContent) {
                ForEach(Array(self.excerpt.contentLinesTrimmed().enumerated()), id: \.offset) { _, paragraph in
                    if !paragraph.isEmpty {
                        Text(paragraph).asContent(self.options)
                    }
                }
            }
            .padding(self.contentPadding)

            HStack(alignment: .bottom, spacing: C.fontSizeFrom) {
                VStack {
                    if !self.excerpt.titleTrimmed.isEmpty {
                        Text(self.excerpt.titleTrimmed).asTitle(self.options)
                    }
                    if !self.excerpt.authorTrimmed.isEmpty {
                        Text(self.excerpt.authorTrimmed).asAuthor(self.options)
                    }
                }
                .frame(maxWidth: .infinity)
                HStack(spacing: 2) {
                    Text("CARD_VIEW_SHARED_VIA_BEGIN").inWatermarkSection()
                    Text("C_APP_NAME").bold().inWatermarkSection()
                    Text("CARD_VIEW_SHARED_VIA_END").inWatermarkSection()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, self.contentPadding)
            .padding(.vertical, self.fromVertPadding)
            .background(Color.black.opacity(0.25))
        }
        .background(C.colorBg)
        .overlay {
            C.colorBg.opacity(0.1)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct BoldCard_Previews: PreviewProvider {
    static let screenEdgePadding: CGFloat = 12

    static var previews: some View {
        ForEach(Array(demoExcerpts.enumerated()), id: \.offset) { i, excerpt in
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        BoldCard(CardOptions(excerpt: excerpt, width: geometry.size.width - screenEdgePadding * 2, font: BoldCard.meta.defaultFont))
                    }
                    .padding(screenEdgePadding)
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }
            }
            .environment(\.locale, .init(identifier: "zh-Hans"))
            .previewDisplayName("Demo \(i + 1)")
        }
    }
}
