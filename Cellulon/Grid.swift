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

public protocol ColorConvertable {
    init(color: Color)
    var color: Color { get }
}

/*
This is an abstract class. It has no actual storage. See Tree, Branch and Leaf.
*/
public class Grid<V : ColorConvertable> {
    
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
    
    public var size: Int {
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

public extension Grid {
    public var bitmap: Bitmap {
        return Bitmap(grid: self)
    }
}

extension Bitmap {
    public convenience init<V:ColorConvertable>(grid: Grid<V>) {
        self.init(size: CGSizeMake(CGFloat(grid.dim), CGFloat(grid.dim)), color: ColorFromCGColor(UIColor.whiteColor().CGColor))
        for i in 0 ..< grid.dim {
            for j in 0 ..< grid.dim {
                let point = GridPoint(x: i, y: j)
                setColor(grid.valueAtPoint(point).color, atPoint: CGPoint(x: i, y: j))
            }
        }
    }
}

public class BasicGrid<V:ColorConvertable> : Grid<V> {
    
    var values: [V]
    
    public init(def: V, ord: Int, values: [V]) {
        self.values = values
        super.init(def: def, ord: ord)
    }

    public override init(def: V, ord: Int) {
        self.values = [V](count: areaForOrder(ord), repeatedValue: def)
        super.init(def: def, ord: ord)
    }

    override public func valueAtPoint(point: GridPoint) -> V {
        return values[indexForPoint(point)]
    }
    
    override public func setValue(value: V, atPoint point: GridPoint) {
        values[indexForPoint(point)] = value
    }
}

extension Int : ColorConvertable {
    public init(color: Color) {
        self = Int(color.v)
    }
    public var color: Color {
        get {
            return Color(v: UInt32(self))
        }
    }
}

public typealias BasicIntGrid = BasicGrid<Int>
