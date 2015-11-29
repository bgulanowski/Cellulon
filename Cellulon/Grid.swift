//
//  Grid.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-11-29.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

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

public class Point<T> {

    let x: T
    let y: T
    
    init(x: T, y: T) {
        self.x = x
        self.y = y
    }
}

public typealias GridPoint = PointI

public protocol Grid_ {
    func valueAtPoint(point: GridPoint) -> Int?
    func setValue(value: Int, atPoint point: GridPoint) -> Void
}

public extension Grid_ {
    
    final func indexForPoint(point: GridPoint, dim: Int) -> Int {
        return point.y * dim + point.x
    }
    
    final func pointForIndex(index: Int, dim: Int) -> GridPoint {
        return GridPoint(x: index%dim, y: index/dim)
    }
}

public class Grid : Grid_ {
    
    let dim: Int
    let siz: Int
    var val: [Int]
    
    init(dim: Int) {
        self.dim = dim
        self.siz = dim * dim
        self.val = [Int](count: siz, repeatedValue: 0)
    }
    
    public final func valueAtPoint(point: GridPoint) -> Int? {
        let index = indexForPoint(point, dim: dim)
        return index < siz ? val[index] : nil
    }
    
    public final func setValue(value: Int, atPoint point: GridPoint) -> Void {
        let index = indexForPoint(point, dim: dim)
        if index < siz {
            val[index] = value
        }
    }
}

public class Tree<T> {
    
    let root: T?
    var limbs: [Int : T]
    
    init(root: T?, limbs: [Int : T]) {
        self.root = root
        self.limbs = limbs
    }
    
    convenience init(root: T?) {
        self.init(root: root, limbs: [Int : T]())
    }
    
    convenience init() {
        self.init(root: nil, limbs: [Int : T]())
    }
}

public class GridTree : Tree<Grid_> {
    
    let dim: Int
    let lev: Int
    let par: GridTree
    
    init(par: GridTree, dim: Int, lev: Int) {
        self.par = par
        self.dim = dim
        self.lev = lev
        super.init(root: nil, limbs: [Int : Grid_]())
    }
    
    public func indexForPoint(point: GridPoint) -> Int {
        return (point.x > dim ? 0 : 1) + (point.y > dim ? 2 : 4)
    }
    
    public func offsetForIndex(index: Int) -> Int {
        return dim * dim * index
    }
    
    public func limbOriginForIndex(index: Int) -> GridPoint {
        return PointI(x: (index & 1) * dim, y: (index & 2) * dim)
    }
    
    public func reverseOffsetPoint(point: GridPoint) -> GridPoint {
        let index = indexForPoint(point)
        let offset = limbOriginForIndex(index)
        return point - offset
    }
    
    public final func limbForPoint(point: Point<Int>) -> Grid_? {
        return limbs[indexForPoint(point, dim: dim)]
    }
}

extension GridTree : Grid_ {
    
    public final func valueAtPoint(point: Point<Int>) -> Int? {
        if let limb = limbForPoint(point) {
            return limb.valueAtPoint(point)
        }
        else {
            return nil
        }
    }
    
    public final func setValue(value: Int, atPoint point: GridPoint) -> Void {
        var limb : Grid_
        if let l = limbForPoint(point) {
            limb = l
        }
        else {
            if lev > 0 {
                limb = Grid(dim: dim)
            }
            else {
                limb = GridTree(par: self, dim: dim, lev: lev-1)
            }
            limbs[indexForPoint(point)] = limb
        }
        limb.setValue(value, atPoint: point)
    }
}
