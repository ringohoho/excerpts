//
//  ShareView.swift
//  excerpts
//
//  Created by Richard on 2023/9/13.
//

import SwiftUI

struct ShareView: View {
    @Environment(\.displayScale) private var envDisplayScale
    @Environment(\.locale) private var envLocale

    @Binding var isPresented: Bool
    @Binding var excerpt: Excerpt

    private func dismiss() {
        self.isPresented = false
    }

    private let screenEdgePadding: CGFloat = 12

    @State private var cardUiImage = UIImage()

    private var cardImage: Image {
        Image(uiImage: self.cardUiImage)
    }

    @State private var isMenuOpen = false

    @AppStorage(UserDefaultsKeys.cardStyle)
    private var cardStyle = CardStyle.defaultValue
    @AppStorage(UserDefaultsKeys.cardFont)
    private var cardFont = CardStyle.defaultValue.meta.defaultFont

    @ViewBuilder
    private func card(width: CGFloat) -> some View {
        self.cardStyle
            .create(.init(excerpt: self.excerpt, width: width, font: self.cardFont))
    }

    @MainActor
    private func renderCard(width: CGFloat) {
        let width = width - self.screenEdgePadding * 2
        let renderer = ImageRenderer(content: self.card(width: width).environment(\.locale, self.envLocale))
        renderer.proposedSize.width = width
        renderer.scale = self.envDisplayScale
        self.cardUiImage = renderer.uiImage!

        self.excerpt.updateWith(sharedImage: self.cardUiImage)
        print("shared image updated: \(self.excerpt.persistentModelID.id)")
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    // scroll view take up full height by default

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
                            self.card(width: geometry.size.width - self.screenEdgePadding * 2)
                                .draggable(self.cardImage)
                        }
                        .padding(self.screenEdgePadding)
                        .frame(width: geometry.size.width)
                        .onAppear {
                            // when the card appear, render it into an Image
                            self.renderCard(width: geometry.size.width)
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
                            Picker("C_STYLE", selection: self.$cardStyle) {
                                ForEach(CardStyle.allCases, id: \.rawValue) { style in
                                    Label(title: { Text(String(localized: style.meta.displayName)) }, icon: { style.meta.miniPreview }).tag(style)
                                }
                            }
                            .menuActionDismissBehavior(.disabled) // force tapping overlay to dismiss menu
                            .onChange(of: self.cardStyle) { style in
                                self.cardFont = style.meta.defaultFont
                                self.renderCard(width: geometry.size.width)
                            }
                            Picker("C_FONT", selection: self.$cardFont) {
                                ForEach(CardFont.allCases, id: \.rawValue) { font in
                                    Text(font.displayName).tag(font)
                                }
                            }
                            .pickerStyle(.menu)
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

// #Preview("Dark") {
//    MainView(demoExcerpts[0], sharing: true)
//        .environment(\.locale, .init(identifier: "zh-Hans"))
//        .preferredColorScheme(.dark)
// }
//
// #Preview("Light Long") {
//    MainView(demoExcerpts[2], sharing: true)
//        .environment(\.locale, .init(identifier: "zh-Hans"))
// }
//
// #Preview("Light English") {
//    MainView(demoExcerpts[3], sharing: true)
//        .environment(\.locale, .init(identifier: "en"))
// }
