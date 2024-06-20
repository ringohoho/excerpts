//
//  Minimal.swift
//  excerpts
//
//  Created by Richard on 2023/11/5.
//

import SwiftUI

private enum C {
    static let colorBackground = Color("FAFBFE")!

    static let fontSizeTitle: CGFloat = 20
    static let colorTitle = Color("030204")!
    static let fontSizeAuthor: CGFloat = 18
    static let colorAuthor = Color("030204")!
    static let fontSizeContent: CGFloat = 17
    static let colorContent = Color("272220")!
    static let fontSizeWatermark: CGFloat = 10
    static let colorWatermark = Color("D0CDCF")!
}

private extension Text {
    func asTitle(_ options: CardOptions) -> some View {
        self.font(options.font.font(size: C.fontSizeTitle))
            .fontWeight(.bold)
            .foregroundStyle(C.colorTitle)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    func asAuthor(_ options: CardOptions, _ alignment: TextAlignment) -> some View {
        let frameAlignment = switch alignment {
        case .leading: Alignment.leading
        case .center: Alignment.center
        case .trailing: Alignment.trailing
        }
        return self.font(options.font.font(size: C.fontSizeAuthor))
            .foregroundStyle(C.colorAuthor)
            .multilineTextAlignment(alignment)
            .frame(maxWidth: .infinity, alignment: frameAlignment)
    }

    func asContent(_ options: CardOptions) -> some View {
        self.font(options.font.font(size: C.fontSizeContent))
            .foregroundStyle(C.colorContent)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineSpacing(C.fontSizeContent * 0.2)
    }

    func inWatermarkSection() -> some View {
        self.font(.system(size: C.fontSizeWatermark))
            .foregroundStyle(C.colorWatermark)
    }
}

struct MinimalCard: Card {
    static let meta: CardMeta = .init(
        displayName: "C_STYLE_MINIMAL",
        miniPreview: .init(systemName: "rectangle.fill"),
        defaultFont: .sourceHanSerif
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

    private let outerPadding: CGFloat = 15

    private var innerWidth: CGFloat {
        self.width - self.outerPadding * 2
    }

    private var contentWidth: CGFloat {
        round(self.innerWidth - C.fontSizeContent * 3, toNearest: self.font.charWidth(size: C.fontSizeContent))
    }

    private var contentHoriOuterPadding: CGFloat {
        (self.innerWidth - self.contentWidth) / 2
    }

    var body: some View {
        VStack(alignment: .trailing) {
            VStack {
                VStack(spacing: C.fontSizeAuthor) {
                    if !self.excerpt.titleTrimmed.isEmpty {
                        VStack(spacing: C.fontSizeTitle * 0.2) {
                            Text(self.excerpt.titleTrimmed).asTitle(self.options)
                            if !self.excerpt.authorTrimmed.isEmpty {
                                Text(self.excerpt.authorTrimmed).asAuthor(self.options, .leading)
                            }
                        }
                    }

                    VStack(spacing: C.fontSizeContent) {
                        ForEach(Array(self.excerpt.contentLinesTrimmed().enumerated()), id: \.offset) { _, paragraph in
                            if !paragraph.isEmpty {
                                Text(paragraph).asContent(self.options)
                            }
                        }
                    }

                    if self.excerpt.titleTrimmed.isEmpty && !self.excerpt.authorTrimmed.isEmpty {
                        Text("CARD_VIEW_AUTHOR_TPLT \(self.excerpt.authorTrimmed)").asAuthor(self.options, .trailing)
                    }
                }
                .padding([.horizontal], self.contentHoriOuterPadding)
                .padding([.vertical], self.contentHoriOuterPadding * 1.3)
            }
            .padding([.horizontal, .top], self.outerPadding)

            HStack(spacing: 2) {
                Text("CARD_VIEW_SHARED_VIA_BEGIN").inWatermarkSection()
                Text(Bundle.main.displayName).bold().inWatermarkSection()
                Text("CARD_VIEW_SHARED_VIA_END").inWatermarkSection()
            }
            .padding([.horizontal, .bottom], self.outerPadding)
        }
        .background(C.colorBackground)
    }
}

// struct MinimalCard_Previews: PreviewProvider {
//    static let screenEdgePadding: CGFloat = 12
//
//    static var previews: some View {
//        ForEach(Array(demoExcerpts.enumerated()), id: \.offset) { i, excerpt in
//            GeometryReader { geometry in
//                ScrollView(.vertical, showsIndicators: false) {
//                    VStack {
//                        MinimalCard(CardOptions(excerpt: excerpt, width: geometry.size.width - screenEdgePadding * 2, font: ClassicCard.meta.defaultFont))
//                    }
//                    .padding(screenEdgePadding)
//                    .frame(width: geometry.size.width)
//                    .frame(minHeight: geometry.size.height)
//                }
//            }
//            .environment(\.locale, .init(identifier: "zh-Hans"))
//            .previewDisplayName("Demo \(i + 1)")
//        }
//    }
// }
