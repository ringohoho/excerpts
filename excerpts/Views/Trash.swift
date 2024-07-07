//
//  Trash.swift
//  excerpts
//
//  Created by Richard on 2024/7/7.
//

import Foundation
import SwiftData

class Trash: ObservableObject {
    @Published var recentDeleted: PersistentIdentifier? = nil
}
