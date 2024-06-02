//
//  BundleExt.swift
//  excerpts
//
//  Created by Richard on 2024/6/2.
//

import Foundation

extension Bundle {
    var displayName: String {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    }
}
