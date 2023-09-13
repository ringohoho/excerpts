//
//  ContentView.swift
//  excerpt
//
//  Created by Richard on 2023/9/9.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            ExcerptsView().navigationTitle("Excerpts")
        }
    }
}

#Preview {
    MainView()
}
