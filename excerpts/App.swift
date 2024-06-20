//
//  App.swift
//  excerpts
//
//  Created by Richard on 2023/9/9.
//

import SwiftData
import SwiftUI

@main
struct MyApp: App {
    var myModelContainer: ModelContainer = {
        let schema = Schema([
            Excerpt.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .private("iCloud.cc.stdrc.app.excerpts.main")
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(myModelContainer)
    }
}
