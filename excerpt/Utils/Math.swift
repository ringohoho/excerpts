//
//  Math.swift
//  excerpt
//
//  Created by Richard on 2023/9/16.
//

import Foundation

func round(_ value: Double, toNearest: Double) -> Double {
    return round(value / toNearest) * toNearest
}
