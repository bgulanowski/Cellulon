//
//  Grid.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

public typealias GridPoint = PointI

/*
This is an abstract class. It has no actual storage. See Tree, Branch and Leaf.
*/
public class Grid<V> {
    
    let def: V
    let dim: Int
    
    public init(def: V, dim: Int) {
        self.def = def
        self.dim = dim
    }
    
    public func min() -> GridPoint {
        return GridPoint(n: 0)
    }
    
    public func max() -> GridPoint {
        return GridPoint(n: dim - 1)
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

public class BasicGrid<V>: Grid<V> {
    
    var values: [V]
    
    public init(def: V, dim: Int, values: [V]) {
        self.values = values
        super.init(def: def, dim: dim)
    }

    public convenience override init(def: V, dim: Int) {
        let values = [V](count: dim * dim, repeatedValue: def)
        self.init(def: def, dim: dim, values: values)
    }

    override public func valueAtPoint(point: GridPoint) -> V {
        return values[indexForPoint(point)]
    }
    
    override public func setValue(value: V, atPoint point: GridPoint) {
        values[indexForPoint(point)] = value
    }
}

public typealias BasicIntGrid = BasicGrid<Int>
