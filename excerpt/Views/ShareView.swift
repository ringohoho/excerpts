//
//  ShareView.swift
//  excerpt
//
//  Created by Richard on 2023/9/13.
//

import SwiftUI

func round(_ value: Double, toNearest: Double) -> Double {
    return round(value / toNearest) * toNearest
}

struct Card: View {
    var excerpt: Excerpt
    var excerptType: ExcerptType
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
                        let lineSep = switch self.excerptType {
                        case .paragraphs: "\n"
                        case .verses, .lyrics: "\n\n"
                        }
                        ForEach(Array(self.excerpt.contentTrimmed.components(separatedBy: lineSep).enumerated()), id: \.offset) { _, paragraph in
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

struct ShareView: View {
    @Binding var isPresented: Bool

    var excerpt: Excerpt
    var excerptType: ExcerptType

    @Environment(\.displayScale) var envDisplayScale
    @Environment(\.locale) var envLocale

    private let screenEdgePadding: CGFloat = 12

    @State private var cardImage = Image(uiImage: UIImage())

    func dismiss() {
        self.isPresented = false
    }

    func createCard(width: CGFloat) -> Card {
        Card(excerpt: self.excerpt, excerptType: self.excerptType, width: width)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                ScrollView(.vertical, showsIndicators: false) {
                    self.createCard(width: geometry.size.width - self.screenEdgePadding * 2)
                        .padding(self.screenEdgePadding)
                        .frame(width: geometry.size.width)
                        .frame(minHeight: geometry.size.height)
                }
                .onAppear {
                    let width = geometry.size.width - self.screenEdgePadding * 2
                    let renderer = ImageRenderer(content: self.createCard(width: width).environment(\.locale, self.envLocale))
                    renderer.proposedSize.width = width
                    renderer.scale = self.envDisplayScale
                    let uiImage = renderer.uiImage!
                    self.cardImage = Image(uiImage: uiImage)
                }

                VStack {
                    Spacer(minLength: 44) // leave a toolbar size here
                    Color.clear
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.dismiss()
                        }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)

                HStack {
                    Spacer()
                    ShareLink(item: self.cardImage, preview: SharePreview(self.excerpt.titleTrimmed, image: self.cardImage)) {
                        Image(systemName: "square.and.arrow.up")
                            .imageScale(.large)
                            .padding([.leading, .trailing], 16)
                            .padding(.bottom, 16)
                    }
                }
            }
            .padding(0)
        }
    }
}

#Preview("D Para.") {
    MainView(demoExcerpts[0], .paragraphs, sharing: true)
        .environment(\.locale, .init(identifier: "zh-Hans"))
        .preferredColorScheme(.dark)
}

#Preview("L Verses") {
    let excerpt = Excerpt(id: UUID(), title: "一首诗", author: "谁", content: "你好。\n我是谁？")
    return MainView(excerpt, .verses, sharing: true)
        .environment(\.locale, .init(identifier: "zh-Hans"))
}

#Preview("L Long Para.") {
    let excerpt = Excerpt(id: UUID(), title: "这是一本名字超长的书：甚至还有副标题", author: "名字超长的作者·甚至还有 Last Name·以及更多", content: demoExcerpts[0].content + "\n\n" + demoExcerpts[0].content + "\n" + demoExcerpts[0].content)
    return MainView(excerpt, .paragraphs, sharing: true)
        .environment(\.locale, .init(identifier: "zh-Hans"))
}

#Preview("L Eng Para.") {
    let excerpt = Excerpt(id: UUID(), title: "The Ten Commandments", author: "Bertrand Russell", content: "Do not feel envious of the happiness of those who live in a fool's paradise, for only a fool will think that it is happiness.")
    return MainView(excerpt, .paragraphs, sharing: true)
        .environment(\.locale, .init(identifier: "en"))
}
