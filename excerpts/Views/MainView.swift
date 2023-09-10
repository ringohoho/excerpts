//
//  ContentView.swift
//  excerpts
//
//  Created by Richard on 2023/9/9.
//

import SwiftUI

enum TabSelection {
    case excerpts
    case settings
}

func tabToTitle(_ tabSelection: TabSelection) -> LocalizedStringKey {
    switch tabSelection {
    case .excerpts: LocalizedStringKey("Excerpts")
    case .settings: LocalizedStringKey("Settings")
    }
}

struct MainView: View {
    @State private var selection: TabSelection = .excerpts

    var navTitle: LocalizedStringKey {
        tabToTitle(self.selection)
    }

    var body: some View {
        NavigationStack {
            TabView(selection: self.$selection) {
                ExcerptsView()
                    .tabItem {
                        Label(tabToTitle(.excerpts), systemImage: "note.text")
                    }
                    .tag(TabSelection.excerpts)
                SettingsView()
                    .tabItem {
                        Label(tabToTitle(.settings), systemImage: "gearshape.fill")
                    }
                    .tag(TabSelection.settings)
            }
            .navigationTitle(self.navTitle)
        }
    }
}

#Preview {
    MainView()
}
