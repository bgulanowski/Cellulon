//
//  PointSubscriptable.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

public protocol PointSubscriptable {
    
    typealias ValueType
    
    func valueAtPoint(point: PointI) -> ValueType
    func setValue(value: ValueType, atPoint point: PointI) -> Void
}

public extension PointSubscriptable {
    subscript(index: PointI) -> ValueType {
        get {
            return valueAtPoint(index)
        }
        set {
            setValue(newValue, atPoint: index)
        }
    }
}

public extension PointSubscriptable {
    
    final func indexForPoint(point: PointI, dim: Int) -> Int {
        return point.y * dim + point.x
    }
    
    final func pointForIndex(index: Int, dim: Int) -> PointI {
        return PointI(x: index%dim, y: index/dim)
    }
    
    public func sectorForPoint(point: PointI) -> Int {
        return (point.x < 0 ? 0 : 1) + (point.y < 0 ? 0 : 2)
    }
    
    public func sectorForPoint(point: PointI, dim: Int) -> Int? {
        if point.x > dim || point.y > dim {
            return nil
        }
        else {
            return sectorForPoint(point - dim)
        }
    }
}
