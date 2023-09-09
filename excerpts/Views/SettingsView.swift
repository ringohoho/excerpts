//
//  SettingsView.swift
//  excerpts
//
//  Created by Richard on 2023/9/9.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Image(systemName: "gearshape")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Settings!")
        }
    }
}

#Preview {
    SettingsView()
}
