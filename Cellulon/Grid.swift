//
//  Grid.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

public typealias GridPoint = PointI

public typealias GridSize = PointI

public extension Point {
    init(w: T, h: T) {
        x = w
        y = h
    }
    var w: T {
        return x
    }
    var h: T {
        return y
    }
}

public extension CGSize {
    var gridSize: GridSize {
        return GridSize(w: Int(width), h: Int(height))
    }
}

/*
This is an abstract class. It has no actual storage. See BasicGrid below.
*/
public class Grid<V : ColorConvertible> {
    
    public let def: V
    public let ord: Int
    public let dim: Int
    
    public init(def: V, ord: Int) {
        self.def = def
        self.ord = ord
        self.dim = pow2(ord)
    }
    
    public var minPoint: GridPoint {
        return GridPoint(n: 0)
    }
    
    public var maxPoint: GridPoint {
        return GridPoint(n: dim - 1)
    }
    
    public var width: Int {
        return dim
    }
    
    public var height: Int {
        return dim
    }
    
    public var size: GridSize {
        return GridSize(w: dim, h: dim)
    }
    
    public var count: Int {
        return areaForOrder(ord)
    }
    
    public func valueAtPoint(point: GridPoint) -> V {
        return def
    }
    
    public func setValue(value: V, atPoint point: GridPoint) -> Void {
    }

    public func indexForPoint(point: GridPoint) -> Int {
        assert(point.x < dim && point.y < dim)
        return point.y * dim + point.x
    }
    
    public func pointForIndex(index: Int) -> GridPoint {
        assert(index < dim * dim)
        return GridPoint(x: index % dim, y: index / dim)
    }
}

public extension Grid {
    subscript(index: GridPoint) -> V {
        get {
            return valueAtPoint(index)
        }
        set {
            setValue(newValue, atPoint: index)
        }
    }
}

public class BasicGrid<V:ColorConvertible> : Grid<V> {
    
    var values: [V]
    
    public init(def: V, ord: Int, values: [V]) {
        self.values = values
        super.init(def: def, ord: ord)
    }

    public override init(def: V, ord: Int) {
        self.values = [V](count: areaForOrder(ord), repeatedValue: def)
        super.init(def: def, ord: ord)
    }

    final override public func valueAtPoint(point: GridPoint) -> V {
        return values[indexForPoint(point)]
    }
    
    final override public func setValue(value: V, atPoint point: GridPoint) {
        values[indexForPoint(point)] = value
    }
}

public typealias BasicIntGrid = BasicGrid<Int>
