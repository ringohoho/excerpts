//
//  AnimationExt.swift
//  excerpts
//
//  Created by Richard on 2024/6/22.
//

import SwiftUI

let animationDuration: CGFloat = 0.2

extension AnyTransition {
    static var shareViewTrans: AnyTransition {
        AnyTransition.offset(y: 60).combined(with: .opacity)
    }
}
