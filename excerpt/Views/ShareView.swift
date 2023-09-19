//
//  ShareView.swift
//  excerpt
//
//  Created by Richard on 2023/9/13.
//

import SwiftUI

struct ShareView: View {
    @Binding var isPresented: Bool

    func dismiss() {
        self.isPresented = false
    }

    var excerpt: Excerpt

    private let screenEdgePadding: CGFloat = 12
    @Environment(\.displayScale) var envDisplayScale
    @Environment(\.locale) var envLocale

    @State private var cardUiImage = UIImage()

    private var cardImage: Image {
        Image(uiImage: self.cardUiImage)
    }

    @State private var isMenuOpen = false

    @State private var selectedStyle = 0
    @State private var selectedFont = 0

    @ViewBuilder
    private func createCard(width: CGFloat) -> some View {
        if self.selectedStyle == 0 {
            ClassicCard(excerpt: self.excerpt, width: width)
        } else {
            EmptyView()
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    // scroll view defaults to take up full height

                    ZStack(alignment: .center) {
                        // invisible rect to dismiss the share view
                        VStack {
                            Color.clear.frame(width: 0, height: 44) // leave a toolbar size here
                            Color.clear
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    self.dismiss()
                                }
                        }
                        .frame(width: geometry.size.width)
                        .frame(maxHeight: .infinity)

                        VStack {
                            self.createCard(width: geometry.size.width - self.screenEdgePadding * 2)
                                .draggable(self.cardImage)
                        }
                        .padding(self.screenEdgePadding)
                        .frame(width: geometry.size.width)
                        .onAppear {
                            // when the card appear, render it into an Image
                            let width = geometry.size.width - self.screenEdgePadding * 2
                            let renderer = ImageRenderer(content: self.createCard(width: width).environment(\.locale, self.envLocale))
                            renderer.proposedSize.width = width
                            renderer.scale = self.envDisplayScale
                            self.cardUiImage = renderer.uiImage!
                        }
                        .onTapGesture {
                            // tap on the card also dismiss the share view
                            self.dismiss()
                        }
                    }
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }

                VStack {
                    // hand-made toolbar
                    HStack(spacing: 16) {
                        Color.clear.frame(maxWidth: 0, maxHeight: 0)

                        Button {
                            self.dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 38, height: 38)
                                .padding(.bottom, 16)
                        }

                        Spacer()

                        Menu {
                            Picker("A_STYLE", selection: self.$selectedStyle) {
                                Label(title: { Text("经典") }, icon: { Image(systemName: "rectangle") }).tag(0)
                                Label(title: { Text("现代") }, icon: { Image(systemName: "rectangle.checkered") }).tag(1)
                                Label(title: { Text("简约") }, icon: { Image(systemName: "rectangle.fill") }).tag(2)
                            }
                            .menuActionDismissBehavior(.disabled) // force tapping overlay to dismiss menu
                            Picker("A_FONT", selection: self.$selectedFont) {
                                Label(title: { Text("系统字体") }, icon: { Image(systemName: "rectangle") }).tag(1)
                                Label(title: { Text("思源宋体") }, icon: { Image(systemName: "rectangle.checkered") }).tag(0)
                            }
                            .menuActionDismissBehavior(.disabled)
                        } label: {
                            Image(systemName: "square.and.pencil.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 38, height: 38)
                                .padding(.bottom, 16)
                        }
                        .onTapGesture {
                            self.isMenuOpen = true
                        }

                        ShareLink(item: self.cardImage, preview: SharePreview(self.excerpt.titleTrimmed, image: self.cardImage)) {
                            Image(systemName: "square.and.arrow.up.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 38, height: 38)
                                .padding([.bottom], 16)
                        }
                        .disabled(self.cardUiImage.size == CGSize())

                        Color.clear.frame(maxWidth: 0, maxHeight: 0)
                    }
                    Spacer()
                }
            }
            .overlay {
                if self.isMenuOpen {
                    // mask all the controls except menu
                    Color.gray.opacity(0.001)
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture {
                            self.isMenuOpen = false
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
