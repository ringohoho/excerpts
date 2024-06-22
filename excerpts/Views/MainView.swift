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
        ZStack {
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
        }
    }
}

#Preview("Main") {
    MainView()
        .environment(\.locale, .init(identifier: "zh-Hans"))
        .modelContainer(MockData.container)
}
