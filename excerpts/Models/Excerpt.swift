//
//  Excerpt.swift
//  excerpts
//
//  Created by Richard on 2023/9/10.
//

import Foundation
import SwiftData
import UIKit

enum ExcerptType: Int, CaseIterable, Hashable, Codable {
    case general = 1010
    case verses = 1015
    case lyrics = 1020

    static let defaultValue = Self.general

    var displayName: String {
        switch self {
        case .general: String(localized: "C_GENERAL_TEXT")
        case .verses: String(localized: "C_VERSES")
        case .lyrics: String(localized: "C_LYRICS")
        }
    }
}

@Model
final class Excerpt {
    var createdAt: Date?
    var updatedAt: Date?

    var type = ExcerptType.general
    var title = ""
    var author = ""
    var content = ""

    @Attribute(.externalStorage)
    var sharedImageData: Data? = nil

    convenience init(_ type: ExcerptType, _ excerptForEdit: ExcerptForEdit) {
        self.init(type, title: excerptForEdit.title, author: excerptForEdit.author, content: excerptForEdit.content)
    }

    init(_ type: ExcerptType, title: String, author: String, content: String) {
        self.createdAt = Date()
        self.updatedAt = Date()
        self.type = type
        self.title = title
        self.author = author
        self.content = content
    }

    func updateWith(_ type: ExcerptType, _ excerptForEdit: ExcerptForEdit) {
        self.updatedAt = Date()
        self.type = type
        self.title = excerptForEdit.title
        self.author = excerptForEdit.author
        self.content = excerptForEdit.content
        self.sharedImageData = nil // invalidate the shared image
    }

    func updateWith(sharedImage: UIImage) {
        self.updatedAt = Date()
        self.sharedImageData = sharedImage.heicData()
    }

    var sharedUIImage: UIImage? {
        if let data = self.sharedImageData {
            UIImage(data: data)
        } else {
            nil
        }
    }

    var titleTrimmed: String {
        self.title.trimmingCharacters(in: .whitespacesAndNewlines).replacing("\n", with: " ")
    }

    var authorTrimmed: String {
        self.author.trimmingCharacters(in: .whitespacesAndNewlines).replacing("\n", with: " ")
    }

    var contentTrimmed: String {
        self.content.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func contentLinesTrimmed() -> [String] {
        self.content
            .components(separatedBy: self.type == .general ? "\n" : "\n\n")
            .map { s in s.trimmingCharacters(in: .whitespaces) }
    }
}

struct ExcerptForEdit {
    var title = ""
    var author = ""
    var content = ""

    init() {}

    init(_ excerpt: Excerpt) {
        self.init(title: excerpt.title, author: excerpt.author, content: excerpt.content)
    }

    init(title: String, author: String, content: String) {
        self.title = title
        self.author = author
        self.content = content
    }

    var isEmpty: Bool {
        self.title.isEmpty && self.author.isEmpty && self.content.isEmpty
    }
}
