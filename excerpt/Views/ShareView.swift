//
//  ShareView.swift
//  excerpt
//
//  Created by Richard on 2023/9/13.
//

import SwiftUI

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

    func createCard(width: CGFloat) -> some View {
        ClassicCard(excerpt: self.excerpt, excerptType: self.excerptType, width: width)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        self.createCard(width: geometry.size.width - self.screenEdgePadding * 2)
                    }
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

#Preview("Dark") {
    MainView(demoExcerpts[0], .paragraphs, sharing: true)
        .environment(\.locale, .init(identifier: "zh-Hans"))
        .preferredColorScheme(.dark)
}

#Preview("Light Long") {
    let excerpt = Excerpt(id: UUID(), title: "这是一本名字超长的书：甚至还有副标题", author: "名字超长的作者·甚至还有 Last Name·以及更多", content: demoExcerpts[0].content + "\n\n" + demoExcerpts[0].content + "\n" + demoExcerpts[0].content)
    return MainView(excerpt, .paragraphs, sharing: true)
        .environment(\.locale, .init(identifier: "zh-Hans"))
}
