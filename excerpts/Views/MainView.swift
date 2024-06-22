//
//  MainView.swift
//  excerpts
//
//  Created by Richard on 2024/6/22.
//

import SwiftUI

struct MainView: View {
    @State private var showShareView: Bool = false

    var body: some View {
        TabView {
            ExcerptView(isSharing: self.$showShareView)
                .tabItem {
                    Label("C_EXCERPT", systemImage: "book.pages")
                }

            HistoryView()
                .tabItem {
                    Label("A_HISTORY", systemImage: "clock")
                }
        }
        .blur(radius: showShareView ? 20 : 0)
        .overlay(showShareView ? Color.gray.opacity(0.2) : Color.clear)
        .animation(.easeInOut(duration: animationDuration), value: showShareView)
    }
}

#Preview("Main") {
    MainView()
        .environment(\.locale, .init(identifier: "zh-Hans"))
        .modelContainer(MockData.container)
}
