//
//  Point.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

public struct Point<T> {
    
    public let x: T
    public let y: T
    
    public init(x: T, y: T) {
        self.x = x
        self.y = y
    }
    
    public init(n: T) {
        self.x = n
        self.y = n
    }
}

public typealias PointI = Point<Int>

// Why does this cause other initializers to become inaccessible?
//public extension Point where T : Int {
//    public convenience init() {
//        self.init(n: 0)
//    }
//}

public func ==(lhs: PointI, rhs: PointI) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

public func +(lhs: PointI, rhs: PointI) -> PointI {
    return PointI(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public prefix func -(lhs: PointI) -> PointI {
    return PointI(x: -lhs.x, y: -lhs.y)
}

public func -(lhs: PointI, rhs: PointI) -> PointI {
    return lhs + (-rhs)
}

public func -(lhs: PointI, rhs: Int) -> PointI {
    return lhs - PointI(n: rhs)
}

public func *(lhs: PointI, rhs: Int) -> PointI {
    return PointI(x: lhs.x * rhs, y: lhs.y * rhs)
}

public func *(lhs: Int, rhs: PointI) -> PointI {
    return PointI(x: lhs * rhs.x, y: lhs * rhs.y)
}

// Cross product and Dot product don't make sense for Integer Points
public func *(lhs: PointI, rhs: PointI) -> PointI {
    return PointI(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
}

public func abs(lhs: PointI) -> PointI {
    return PointI(x: abs(lhs.x), y: abs(lhs.y))
}
