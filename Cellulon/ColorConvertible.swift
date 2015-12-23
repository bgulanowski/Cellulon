//
//  ColorConvertible.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-22.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

public protocol ColorConvertible {
    init(color: Color)
    var color: Color { get }
}

let opaqueBlack = Color(v: NSSwapBigIntToHost(0x000000FF))
let opaqueWhite = Color(v: UINT32_MAX)

extension Bool : ColorConvertible {
    public init(color: Color) {
        self = color.v > UINT32_MAX / 2
    }
    public var color: Color {
        return self ? opaqueBlack : opaqueWhite
    }
}

extension UInt8 : ColorConvertible {
    public init(color: Color) {
        self = UInt8(color.v)
    }
    public var color: Color {
        return Color(v: UInt32(self))
    }
}

extension Int : ColorConvertible {
    public init(color: Color) {
        self = Int(color.v)
    }
    public var color: Color {
        get {
            return Color(v: UInt32(self))
        }
    }
}
