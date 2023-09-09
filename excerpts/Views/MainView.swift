//
//  ContentView.swift
//  excerpts
//
//  Created by Richard on 2023/9/9.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ExcerptsView()
                .tabItem {
                    Label(LocalizedStringKey("Excerpts"), systemImage: "note.text")
                }
            SettingsView()
                .tabItem {
                    Label(LocalizedStringKey("Settings"), systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    MainView()
}
