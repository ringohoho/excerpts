//
//  ShareView.swift
//  excerpts
//
//  Created by Richard on 2023/9/13.
//

import Foundation
import LinkPresentation
import SwiftUI

struct ShareView: View {
    @Environment(\.displayScale) private var envDisplayScale
    @Environment(\.locale) private var envLocale
    @Environment(\.dismiss) var dismiss

    @Binding var excerpt: Excerpt
    let mutable: Bool

    @State private var cardPlatImage: UIImage

    init(excerpt: Binding<Excerpt>, mutable: Bool) {
        self._excerpt = excerpt
        let defaultPlatImage = UIImage()
        self._cardPlatImage = State(initialValue: excerpt.wrappedValue.sharedPlatImage ?? defaultPlatImage)
        self.mutable = mutable
    }

    @State private var isStyleMenuOpen = false
    @State private var isShareMenuOpen = false

    /// Only valid on iOS devices, because on macOS the menu will dismiss regardless of `.menuActionDismissBehavior(.disabled)`.
    private var isMenuOpen: Bool {
        self.isStyleMenuOpen || self.isShareMenuOpen
    }

    @AppStorage(UserDefaultsKeys.cardStyle)
    private var cardStyle = CardStyle.defaultValue
    @AppStorage(UserDefaultsKeys.cardFont)
    private var cardFont = CardStyle.defaultValue.meta.defaultFont

    private var cardImage: Image {
        Image(uiImage: self.cardPlatImage)
    }

    @ViewBuilder
    private func card(width: CGFloat) -> some View {
        self.cardStyle
            .create(.init(excerpt: self.excerpt, width: width, font: self.cardFont))
    }

    @MainActor
    private func renderCard(width: CGFloat) {
        let renderer = ImageRenderer(content: self.card(width: width).environment(\.locale, self.envLocale))
        renderer.proposedSize.width = width
        renderer.scale = self.envDisplayScale
        self.cardPlatImage = renderer.uiImage!

        self.excerpt.updateWith(sharedPlatImage: self.cardPlatImage)
        print("shared image updated: \(self.excerpt.id)")
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
                            if self.mutable {
                                // from ExcerptView, should re-render it
                                self.card(width: CardConsts.cardWidth(geometry.size.width))
                                    .draggable(self.cardImage)
                            } else {
                                // immutable, should display saved image
                                self.cardImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: CardConsts.cardWidth(geometry.size.width))
                                    .draggable(self.cardImage)
                            }
                        }
                        .padding(CardConsts.cardContainerPadding)
                        .frame(maxWidth: CardConsts.maxCardContainerWidth)
                        .onAppear {
                            if self.mutable {
                                // it's from ExcerptView
                                self.renderCard(width: CardConsts.cardWidth(geometry.size.width))
                            }
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

                        if self.mutable {
                            Menu {
                                Picker("C_STYLE", selection: self.$cardStyle) {
                                    ForEach(CardStyle.allCases, id: \.rawValue) { style in
                                        Label(title: { Text(String(localized: style.meta.displayName)) }, icon: { style.meta.miniPreview }).tag(style)
                                    }
                                }
                                .menuActionDismissBehavior(.disabled) // force tapping overlay to dismiss menu
                                .onChange(of: self.cardStyle) {
                                    self.cardFont = self.cardStyle.meta.defaultFont
                                    self.renderCard(width: CardConsts.cardWidth(geometry.size.width))
                                }
                                Picker("C_FONT", selection: self.$cardFont) {
                                    ForEach(CardFont.allCases, id: \.rawValue) { font in
                                        Text(font.displayName).tag(font)
                                    }
                                }
                                .pickerStyle(.menu)
                                .menuActionDismissBehavior(.disabled)
                                .onChange(of: self.cardFont) {
                                    self.renderCard(width: CardConsts.cardWidth(geometry.size.width))
                                }
                            } label: {
                                Image(systemName: "square.and.pencil.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 38, height: 38)
                                    .padding(.bottom, 16)
                            }
                            .onTapGesture {
                                self.isStyleMenuOpen = true
                            }
                        }

                        let shareButtonImage = Image(systemName: "square.and.arrow.up.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 38, height: 38)
                            .padding([.bottom], 16)
                        #if targetEnvironment(simulator)
                        // ActivityViewController doesn't work properly in simulator especially in preview
                        ShareLink(item: self.cardImage, preview: SharePreview(self.excerpt.titleTrimmed, image: self.cardImage)) {
                            shareButtonImage
                        }
                        .disabled(self.cardPlatImage.size == CGSize())
                        // the problem of ShareLink is that it doesn't support custom onTapGesture action,
                        // so that on iPad we cannot display the overlay to prevent from dismissing the ShareView
                        // when tapping
                        #else
                        Button {
                            self.isShareMenuOpen = true
                        } label: {
                            shareButtonImage
                        }
                        .sheet(isPresented: self.$isShareMenuOpen) {
                            ActivityViewController(activityItems: [ImageForShare(image: self.cardPlatImage, title: self.excerpt.titleTrimmed, subtitle: self.excerpt.authorTrimmed)])
                                .ignoresSafeArea(edges: .bottom)
                                .presentationDetents([.medium, .large])
                                .presentationDragIndicator(.hidden)
                        }
                        .disabled(self.cardPlatImage.size == CGSize())
                        #endif

                        Color.clear.frame(maxWidth: 0, maxHeight: 0)
                    }
                    Spacer()
                }
            }
            .overlay {
                if self.isMenuOpen && !ProcessInfo.processInfo.isiOSAppOnMac {
                    // mask all the controls except menu
                    Color.gray.opacity(0.001)
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture {
                            self.isStyleMenuOpen = false
                            self.isShareMenuOpen = false
                        }
                }
            }
        }
    }
}

// see https://stackoverflow.com/a/58341956
struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}

class ImageForShare: NSObject {
    var image: UIImage
    var title: String
    var subtitle: String

    init(image: UIImage, title: String, subtitle: String) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
    }
}

// see https://stackoverflow.com/a/58234878
extension ImageForShare: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        UIImage()
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        self.image
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = self.title // title
        metadata.originalURL = URL(string: self.subtitle) // subtitle
        metadata.imageProvider = NSItemProvider(object: self.image)
        metadata.iconProvider = NSItemProvider(object: self.image)
        return metadata
    }
}

#Preview("Dark") {
    ExcerptView(demoExcerpts[0], sharing: true)
        .environment(\.locale, .init(identifier: "zh-Hans"))
        .modelContainer(MockData.container)
        .preferredColorScheme(.dark)
}

#Preview("Light Long") {
    ExcerptView(demoExcerpts[2], sharing: true)
        .environment(\.locale, .init(identifier: "zh-Hans"))
        .modelContainer(MockData.container)
}

#Preview("Light English") {
    ExcerptView(demoExcerpts[3], sharing: true)
        .environment(\.locale, .init(identifier: "en"))
        .modelContainer(MockData.container)
}
