//
//  Classic.swift
//  excerpt
//
//  Created by Richard on 2023/9/16.
//

import SwiftUI

struct ClassicCard: View {
    var excerpt: Excerpt
    var width: CGFloat

    private let fontName = "SourceHanSerifSC-Regular"
    private let fontSizeContent: CGFloat = 17
    private let fontSizeFrom: CGFloat = 14
    private let fontSizeWatermark: CGFloat = 10
    private let colorBackground = Color("F9F9FB")!
    private let colorContent = Color("272220")!
    private let colorFrom = Color("514A48")!
    private let colorBorder = Color("D0CDCF")!
    private let colorWatermark = Color("D0CDCF")!

    private let rectOuterPadding: CGFloat = 15

    private var rectInnerWidth: CGFloat {
        self.width - self.rectOuterPadding * 2
    }

    private var contentWidth: CGFloat {
        round(self.rectInnerWidth - self.fontSizeContent * 3, toNearest: self.fontSizeContent)
    }

    private var contentVertOuterPadding: CGFloat {
        (self.rectInnerWidth - self.contentWidth) / 2
    }

    private var contentFromSpacing: CGFloat {
        self.contentVertOuterPadding
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                VStack(spacing: self.contentFromSpacing) {
                    VStack(spacing: self.fontSizeContent) {
                        ForEach(Array(self.excerpt.contentLinesTrimmed().enumerated()), id: \.offset) { _, paragraph in
                            let p = paragraph.trimmingCharacters(in: .whitespaces)
                            if !p.isEmpty {
                                Text(p)
                                    .font(.custom(self.fontName, size: self.fontSizeContent))
                                    .foregroundColor(self.colorContent)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineSpacing(self.fontSizeContent * 0.2)
                            }
                        }
                    }

                    if !(self.excerpt.titleTrimmed.isEmpty && self.excerpt.authorTrimmed.isEmpty) {
                        VStack(spacing: self.fontSizeFrom * 0.2) {
                            if self.excerpt.type != .lyrics {
                                if !self.excerpt.authorTrimmed.isEmpty {
                                    Text("CARD_VIEW_AUTHOR_TPLT \(self.excerpt.authorTrimmed)")
                                        .font(.custom(self.fontName, size: self.fontSizeFrom))
                                        .foregroundColor(self.colorFrom)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .multilineTextAlignment(.trailing)
                                }
                                if !self.excerpt.titleTrimmed.isEmpty {
                                    Text(self.excerpt.titleTrimmed)
                                        .font(.custom(self.fontName, size: self.fontSizeFrom))
                                        .foregroundColor(self.colorFrom)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .multilineTextAlignment(.trailing)
                                }
                            } else {
                                if !self.excerpt.titleTrimmed.isEmpty {
                                    Text(self.excerpt.titleTrimmed)
                                        .font(.custom(self.fontName, size: self.fontSizeFrom))
                                        .foregroundColor(self.colorFrom)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .multilineTextAlignment(.trailing)
                                }
                                if !self.excerpt.authorTrimmed.isEmpty {
                                    Text(self.excerpt.authorTrimmed)
                                        .font(.custom(self.fontName, size: self.fontSizeFrom))
                                        .foregroundColor(self.colorFrom)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .multilineTextAlignment(.trailing)
                                }
                            }
                        }
                    }
                }
                .padding([.leading, .trailing], self.contentVertOuterPadding)
                .padding([.top, .bottom], self.contentVertOuterPadding * 1.6)
                .border(self.colorBorder, width: 0.7)
                .overlay {
                    Rectangle()
                        .fill(Color.clear)
                        .border(self.colorBorder, width: 0.5)
                        .padding(2)
                }
            }
            .padding([.leading, .top, .trailing], self.rectOuterPadding)
            .padding(.bottom, 3)

            HStack(spacing: 2) {
                Text("CARD_VIEW_SHARED_VIA_BEGIN")
                    .font(.system(size: self.fontSizeWatermark))
                    .foregroundColor(self.colorWatermark)
                Text("C_APP_NAME")
                    .font(.system(size: self.fontSizeWatermark))
                    .foregroundColor(self.colorWatermark)
                    .bold()
                Text("CARD_VIEW_SHARED_VIA_END")
                    .font(.system(size: self.fontSizeWatermark))
                    .foregroundColor(self.colorWatermark)
            }
            .padding([.leading, .bottom, .trailing], self.rectOuterPadding)
        }
        .background(self.colorBackground)
    }
}

struct ClassicCard_Previews: PreviewProvider {
    static let screenEdgePadding: CGFloat = 12

    static var previews: some View {
        ForEach(Array(demoExcerpts.enumerated()), id: \.offset) { i, excerpt in
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ClassicCard(excerpt: excerpt, width: geometry.size.width - screenEdgePadding * 2)
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
