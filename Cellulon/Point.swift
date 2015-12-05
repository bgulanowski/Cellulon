//
//  Point.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

public class Point<T> {
    
    let x: T
    let y: T
    
    init(x: T, y: T) {
        self.x = x
        self.y = y
    }
    
    init(n: T) {
        self.x = n
        self.y = n
    }
}

public typealias PointI = Point<Int>

public func +(lhs: PointI, rhs: PointI) -> PointI {
    return PointI(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public prefix func -(lhs: PointI) -> PointI {
    return PointI(x: -lhs.x, y: -lhs.y)
}

public func -(lhs: PointI, rhs: PointI) -> PointI {
    return PointI(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

public func -(lhs: PointI, rhs: Int) -> PointI {
    return lhs - PointI(n: rhs)
}

public func *(lhs: PointI, rhs: Int) -> PointI {
    return PointI(x: lhs.x * rhs, y: lhs.y * rhs)
}

// Cross product and Dot product don't make sense for Integer Points
public func *(lhs: PointI, rhs: PointI) -> PointI {
    return PointI(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
}

public func abs(lhs: PointI) -> PointI {
    return PointI(x: abs(lhs.x), y: abs(lhs.y))
}
