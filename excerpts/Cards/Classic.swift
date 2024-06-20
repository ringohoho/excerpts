//
//  Classic.swift
//  excerpts
//
//  Created by Richard on 2023/9/16.
//

import SwiftUI

private enum C {
    static let colorBackground = Color("F9F9FB")!
    static let colorBorder = Color("D0CDCF")!

    static let fontSizeContent: CGFloat = 17
    static let colorContent = Color("272220")!
    static let fontSizeFrom: CGFloat = 14
    static let colorFrom = Color("514A48")!
    static let fontSizeWatermark: CGFloat = 10
    static let colorWatermark = Color("D0CDCF")!
}

private extension Text {
    func inContentSection(_ options: CardOptions) -> some View {
        self.font(options.font.font(size: C.fontSizeContent))
            .foregroundStyle(C.colorContent)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineSpacing(C.fontSizeContent * 0.2)
    }

    func inFromSection(_ options: CardOptions) -> some View {
        self.font(options.font.font(size: C.fontSizeFrom))
            .foregroundStyle(C.colorFrom)
            .multilineTextAlignment(.trailing)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }

    func inWatermarkSection() -> some View {
        self.font(.system(size: C.fontSizeWatermark))
            .foregroundStyle(C.colorWatermark)
    }
}

struct ClassicCard: Card {
    static let meta: CardMeta = .init(
        displayName: "C_STYLE_CLASSIC",
        miniPreview: .init(systemName: "rectangle"),
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

    private let rectOuterPadding: CGFloat = 15

    private var rectInnerWidth: CGFloat {
        self.width - self.rectOuterPadding * 2
    }

    private var contentWidth: CGFloat {
        round(self.rectInnerWidth - C.fontSizeContent * 3, toNearest: self.font.charWidth(size: C.fontSizeContent))
    }

    private var contentHoriOuterPadding: CGFloat {
        (self.rectInnerWidth - self.contentWidth) / 2
    }

    private var contentFromSpacing: CGFloat {
        self.contentHoriOuterPadding
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                VStack(spacing: self.contentFromSpacing) {
                    VStack(spacing: C.fontSizeContent) {
                        ForEach(Array(self.excerpt.contentLinesTrimmed().enumerated()), id: \.offset) { _, paragraph in
                            if !paragraph.isEmpty {
                                Text(paragraph).inContentSection(self.options)
                            }
                        }
                    }

                    if !(self.excerpt.titleTrimmed.isEmpty && self.excerpt.authorTrimmed.isEmpty) {
                        VStack(spacing: C.fontSizeFrom * 0.2) {
                            if self.excerpt.type != .lyrics {
                                if !self.excerpt.authorTrimmed.isEmpty {
                                    Text("CARD_VIEW_AUTHOR_TPLT \(self.excerpt.authorTrimmed)").inFromSection(self.options)
                                }
                                if !self.excerpt.titleTrimmed.isEmpty {
                                    Text(self.excerpt.titleTrimmed).inFromSection(self.options)
                                }
                            } else {
                                if !self.excerpt.titleTrimmed.isEmpty {
                                    Text(self.excerpt.titleTrimmed).inFromSection(self.options)
                                }
                                if !self.excerpt.authorTrimmed.isEmpty {
                                    Text(self.excerpt.authorTrimmed).inFromSection(self.options)
                                }
                            }
                        }
                    }
                }
                .padding([.horizontal], self.contentHoriOuterPadding)
                .padding([.vertical], self.contentHoriOuterPadding * 1.6)
                .border(C.colorBorder, width: 0.7)
                .overlay {
                    Color.clear
                        .border(C.colorBorder, width: 0.5)
                        .padding(2)
                }
            }
            .padding([.horizontal, .top], self.rectOuterPadding)
            .padding(.bottom, 3)

            HStack(spacing: 2) {
                Text("CARD_VIEW_SHARED_VIA_BEGIN").inWatermarkSection()
                Text(Bundle.main.displayName).bold().inWatermarkSection()
                Text("CARD_VIEW_SHARED_VIA_END").inWatermarkSection()
            }
            .padding([.horizontal, .bottom], self.rectOuterPadding)
        }
        .background(C.colorBackground)
    }
}

// struct ClassicCard_Previews: PreviewProvider {
//    static let screenEdgePadding: CGFloat = 12
//
//    static var previews: some View {
//        ForEach(Array(demoExcerpts.enumerated()), id: \.offset) { i, excerpt in
//            GeometryReader { geometry in
//                ScrollView(.vertical, showsIndicators: false) {
//                    VStack {
//                        ClassicCard(CardOptions(excerpt: excerpt, width: geometry.size.width - screenEdgePadding * 2, font: ClassicCard.meta.defaultFont))
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
