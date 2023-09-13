//
//  Excerpt.swift
//  excerpt
//
//  Created by Richard on 2023/9/10.
//

import Foundation

struct Excerpt: Hashable, Codable, Identifiable {
    var id: UUID
    var content: String
    var book: String
    var author: String
}
