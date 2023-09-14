//
//  ShareView.swift
//  quoter
//
//  Created by Richard on 2023/9/13.
//

import SwiftUI

func round(_ value: Double, toNearest: Double) -> Double {
    return round(value / toNearest) * toNearest
}

struct Card: View {
    var quote: Quote
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

    private var quoteContent: String {
        self.quote.content.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var quoteAuthor: String {
        self.quote.author
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacing("\n", with: " ")
    }

    private var quoteBook: String {
        self.quote.book.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacing("\n", with: " ")
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                VStack(spacing: self.contentFromSpacing) {
                    VStack(spacing: self.fontSizeContent) {
                        ForEach(Array(self.quoteContent.components(separatedBy: "\n").enumerated()), id: \.offset) { _, paragraph in
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

                    if !(self.quoteBook.isEmpty && self.quoteAuthor.isEmpty) {
                        VStack(spacing: self.fontSizeFrom * 0.2) {
                            if !self.quoteAuthor.isEmpty {
                                Text("— \(self.quote.author)")
                                    .font(.custom(self.fontName, size: self.fontSizeFrom))
                                    .foregroundColor(self.colorFrom)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .multilineTextAlignment(.trailing)
                            }
                            if !self.quoteBook.isEmpty {
                                Text(self.quote.book)
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
                Text("CARD_SHARED_VIA")
                    .font(.system(size: self.fontSizeWatermark))
                    .foregroundColor(self.colorBorder)
                Text("MAIN_VIEW_TITLE")
                    .font(.system(size: self.fontSizeWatermark))
                    .bold()
                    .foregroundColor(self.colorWatermark)
            }
            .padding([.leading, .bottom, .trailing], self.rectOuterPadding)
        }
        .background(self.colorBackground)
    }
}

struct ShareView: View {
    @Binding var isPresented: Bool

    @Environment(\.displayScale) var envDisplayScale
    @Environment(\.locale) var envLocale

    var quote: Quote

    private let screenEdgePadding: CGFloat = 12

    func dismiss() {
        self.isPresented = false
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    Card(quote: self.quote, width: geometry.size.width - self.screenEdgePadding * 2)
                        .padding(12)
                        .frame(width: geometry.size.width)
                        .frame(minHeight: geometry.size.height - 44 - 12 /* TODO: magic number */ )
                }
                .onTapGesture {
                    self.dismiss()
                }

                HStack {
                    Button("A_SAVE_TO_PHOTO_LIBRARY") {
                        let width = geometry.size.width - self.screenEdgePadding * 2
                        let renderer = ImageRenderer(content: Card(quote: self.quote, width: width).environment(\.locale, self.envLocale))
                        renderer.proposedSize.width = width
                        renderer.scale = self.envDisplayScale

                        if let uiImage = renderer.uiImage {
                            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                        }

                        self.dismiss()
                    }
                    .frame(height: 44)
                    .padding([.leading, .trailing], 20)
                }
                .background(Color.clear)
                .padding(.bottom, 12)
            }
            .padding(0)
        }
    }
}

#Preview("Share Dark") {
    MainView(quotes[0], sharing: true)
        .environment(\.locale, .init(identifier: "zh-Hans"))
        .preferredColorScheme(.dark)
}

#Preview("Share Short Light") {
    MainView(Quote(id: UUID(), content: "你好。", book: "一本书", author: "谁"), sharing: true)
        .environment(\.locale, .init(identifier: "zh-Hans"))
}

#Preview("Share Long") {
    MainView(Quote(id: UUID(), content: quotes[0].content + "\n" + quotes[0].content + "\n" + quotes[0].content, book: "这是一本名字超长的书：甚至还有副标题", author: "名字超长的作者·甚至还有 Last Name·以及更多"), sharing: true)
        .environment(\.locale, .init(identifier: "zh-Hans"))
}

#Preview("Share English") {
    MainView(Quote(id: UUID(), content: "Do not feel envious of the happiness of those who live in a fool's paradise, for only a fool will think that it is happiness.", book: "The Ten Commandments", author: "Bertrand Russell"), sharing: true)
        .environment(\.locale, .init(identifier: "en"))
}
