//
//  MockData.swift
//  excerpts
//
//  Created by Richard on 2024/6/21.
//

import Foundation
import SwiftData

@MainActor
class MockData {
    static var container: ModelContainer {
        let schema = Schema([
            Excerpt.self,
        ])

        let container = try! ModelContainer(
            for: schema,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

        for excerpt in demoExcerpts {
            container.mainContext.insert(excerpt)
        }

        return container
    }
}
