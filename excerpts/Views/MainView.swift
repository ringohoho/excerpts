//
//  MainView.swift
//  excerpts
//
//  Created by Richard on 2024/6/22.
//

import SwiftUI

struct MainView: View {
    @State private var isSharing1: Bool = false
    @State private var isSharing2: Bool = false

    var shouldBlur: Bool {
        self.isSharing1 || self.isSharing2
    }

    var body: some View {
        TabView {
            ExcerptView(isSharing: self.$isSharing1)
                .tabItem {
                    Label("C_EXCERPT", systemImage: "book.pages")
                }

            HistoryView(isSharing: self.$isSharing2)
                .tabItem {
                    Label("A_HISTORY", systemImage: "clock")
                }
        }
        .blur(radius: self.shouldBlur ? 20 : 0)
        .overlay(self.shouldBlur ? Color.gray.opacity(0.2) : Color.clear)
        .animation(.easeInOut(duration: animationDuration), value: self.shouldBlur)
    }
}

#Preview("Main") {
    MainView()
        .environment(\.locale, .init(identifier: "zh-Hans"))
        .modelContainer(MockData.container)
}
