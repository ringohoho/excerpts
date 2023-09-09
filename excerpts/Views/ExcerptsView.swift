//
//  ExcerptsView.swift
//  excerpts
//
//  Created by Richard on 2023/9/9.
//

import SwiftUI

struct ExcerptsView: View {
    var body: some View {
        VStack {
            Image(systemName: "note.text")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Excerpts!")
        }
    }
}

#Preview {
    ExcerptsView()
}
