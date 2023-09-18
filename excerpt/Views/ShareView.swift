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

    @Environment(\.displayScale) var envDisplayScale
    @Environment(\.locale) var envLocale

    private let screenEdgePadding: CGFloat = 12

    @State private var cardImage = Image(uiImage: UIImage())

    func dismiss() {
        self.isPresented = false
    }

    func createCard(width: CGFloat) -> some View {
        ClassicCard(excerpt: self.excerpt, width: width)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    // scroll view defaults to take up full height

                    ZStack(alignment: .center) {
                        // invisible rect to dismiss the share view
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

                        VStack {
                            self.createCard(width: geometry.size.width - self.screenEdgePadding * 2)
                                .contextMenu {
                                    // allow user to share in context menu, if they don't see the up-right button
                                    ShareLink(item: self.cardImage, preview: SharePreview(self.excerpt.titleTrimmed, image: self.cardImage)) {
                                        Text("A_SHARE")
                                    }
                                }
                        }
                        .padding(self.screenEdgePadding)
                        .frame(width: geometry.size.width)
                        .onAppear {
                            // when the card appear, render it into an Image
                            let width = geometry.size.width - self.screenEdgePadding * 2
                            let renderer = ImageRenderer(content: self.createCard(width: width).environment(\.locale, self.envLocale))
                            renderer.proposedSize.width = width
                            renderer.scale = self.envDisplayScale
                            let uiImage = renderer.uiImage!
                            self.cardImage = Image(uiImage: uiImage)
                        }
                        .onTapGesture {
                            // tap on the card also dismiss the share view
                            self.dismiss()
                        }
                    }
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }

                HStack {
                    Spacer()
                    ShareLink(item: self.cardImage, preview: SharePreview(self.excerpt.titleTrimmed, image: self.cardImage)) {
                        Image(systemName: "square.and.arrow.up")
                            .imageScale(.large)
                            .padding([.horizontal], 16)
                            .padding(.bottom, 16)
                    }
                }
            }
        }
    }
}

#Preview("Dark") {
    MainView(demoExcerpts[0], sharing: true)
        .environment(\.locale, .init(identifier: "zh-Hans"))
        .preferredColorScheme(.dark)
}

#Preview("Light Long") {
    return MainView(demoExcerpts[2], sharing: true)
        .environment(\.locale, .init(identifier: "zh-Hans"))
}

#Preview("Light English") {
    MainView(demoExcerpts[3], sharing: true)
        .environment(\.locale, .init(identifier: "en"))
}
