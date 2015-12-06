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
    
    public func valueAtPoint(point: GridPoint) -> V {
        return def
    }
    
    public func setValue(value: V, atPoint point: GridPoint) -> Void {
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

extension Grid {
    func indexForPoint(point: GridPoint) -> Int {
        return point.y * dim + point.x
    }
    
    func pointForIndex(index: Int) -> GridPoint {
        return GridPoint(x: index % dim, y: index / dim)
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
