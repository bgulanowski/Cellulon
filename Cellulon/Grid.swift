//
//  Grid.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

func pow2(exponent: Int) -> Int {
    return Int(pow(2.0, Double(exponent)))
}

func areaForOrder(ord : Int) -> Int {
    let dim = pow2(ord)
    return dim * dim
}

public typealias GridPoint = PointI

/*
This is an abstract class. It has no actual storage. See Tree, Branch and Leaf.
*/
public class Grid<V> {
    
    let def: V
    let ord: Int
    let dim: Int
    
    public init(def: V, ord: Int) {
        self.def = def
        self.ord = ord
        self.dim = pow2(ord)
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
    
    public init(def: V, ord: Int, values: [V]) {
        self.values = values
        super.init(def: def, ord: ord)
    }

    public override init(def: V, ord: Int) {
        let area = areaForOrder(ord)
        self.values = [V](count: area, repeatedValue: def)
        super.init(def: def, ord: ord)
    }

    override public func valueAtPoint(point: GridPoint) -> V {
        return values[indexForPoint(point)]
    }
    
    override public func setValue(value: V, atPoint point: GridPoint) {
        values[indexForPoint(point)] = value
    }
}

public typealias BasicIntGrid = BasicGrid<Int>
