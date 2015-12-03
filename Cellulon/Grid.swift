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

public typealias GridPoint = PointI

public class Grid<V> : PointSubscriptable {
    
    public typealias ValueType = V
    
    let dim: Int
    let siz: Int
    var val: [V]
    var def: V
    
    init(dim: Int, def: V) {
        self.dim = dim
        self.siz = dim * dim
        self.val = [V](count: siz, repeatedValue: def )
        self.def = def
    }
    
    public final func valueAtPoint(point: GridPoint) -> V {
        let index = indexForPoint(point, dim: dim)
        return index < siz ? val[index] : def
    }
    
    public final func setValue(value: V, atPoint point: GridPoint) -> Void {
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

public class GridTree<T:PointSubscriptable> : Tree<T> {
    
    public typealias ValueType = T.ValueType
    
    let par: GridTree?
    let dim: Int
    let lev: Int
    let def: ValueType
    
    init(par: GridTree?, dim: Int, lev: Int, def: ValueType) {
        self.par = par
        self.dim = dim
        self.lev = lev
        self.def = def
        super.init(root: nil, limbs: [Int : T]())
    }
    
    convenience init(dim: Int, def: ValueType) {
        self.init(par: nil, dim: dim, lev: 0, def: def)
    }
    
    public func offsetForIndex(index: Int) -> Int {
        return dim * dim * index
    }
    
    public func originForSector(sector: Int) -> GridPoint {
        return PointI(x: (sector & 1) * dim, y: (sector & 2) * dim)
    }
    
    public func reverseOffsetPoint(point: GridPoint) -> GridPoint {
        return point - reverseOffsetForPoint(point)
    }
    
    public func reverseOffsetForPoint(point: GridPoint) -> GridPoint {
        if let sector : Int = sectorForPoint(point, dim: dim) {
            return originForSector(sector)
        }
        else {
            return GridPoint(n: 0)
        }
    }
    
    public final func limbForPoint(point: Point<Int>) -> T? {
        return limbs[indexForPoint(point, dim: dim)]
    }
}

extension GridTree : PointSubscriptable {
    
    public final func valueAtPoint(point: Point<Int>) -> ValueType {
        if let limb = limbForPoint(point) {
            return limb.valueAtPoint(point)
        }
        else {
            return def
        }
    }
    
    public final func setValue(value: ValueType, atPoint point: GridPoint) -> Void {
        var limb: T? = nil
        if let l = limbForPoint(point) {
            limb = l
        }
        else if let sector = sectorForPoint(point, dim: dim) {
            limb = newLimb()
            limbs[sector] = limb
        }
        limb?.setValue(value, atPoint: point)
    }
    
    final func newBranch() -> GridTree<T> {
        return GridTree<T>(par: self, dim: dim, lev: lev-1, def: def)
    }
    
    final func newLeaf() -> Grid<T.ValueType> {
        return Grid<T.ValueType>(dim: dim, def: def)
    }
    
    final func newLimb() -> T {
        // FIXME: there is a property type that both GridTree<T> and Grid<T.ValueType> conform to?
        let result: T = lev == 0 ? newLeaf() as! T : newBranch() as! T
        return result
    }
}

public enum GridSector : Int {
    case s0 = 0
    case s1 = 1
    case s2 = 2
    case s3 = 3
}

public class Grove<T:PointSubscriptable>: PointSubscriptable {
    
    // FIXME: use Sector instead of Int
    
    let leafDim: Int
    var treeDim: Int
    var trees = [ Int : GridTree<T> ]()
    let def: T.ValueType
    
    init(dim: Int, def: T.ValueType) {
        self.leafDim = dim
        self.treeDim = 2 * dim
        self.def = def
    }
    
    public final func valueAtPoint(point: GridPoint) -> T.ValueType {
        if let tree = treeForPoint(point) {
            return tree.valueAtPoint(abs(point))
        }
        else {
            return def
        }
    }
    
    public final func setValue(value: T.ValueType, atPoint point: GridPoint) -> Void {
        // FIXME: check the sector, grow if needed
        treeForPoint(point)?.setValue(value, atPoint: abs(point))
    }
    
    final func growForPoint(point: GridPoint) -> Void {
        // FIXME: grow the tree in the given sector until it holds point
    }
    
    final func growTreeInSector(sector: Int) -> Void {
        // FIXME: double the size of the specified tree
    }
    
    final func treeForPoint(point: GridPoint) -> GridTree<T>? {
        return trees[sectorForPoint(point)]
    }
    
    final func transformPoint(point: GridPoint, forSector sector: Int) -> GridPoint {
        return point * transformForSector(sector)
    }
    
    final func transformForSector(sector: Int) -> GridPoint {
        return GridPoint(x: sector & 1 == 0 ? 1 : -1, y: sector & 2 == 0 ? 1 : -1)
    }
    
    final func treeInSector(sector: Int) -> GridTree<T>? {
        return (trees[sector] != nil) ? trees[sector] : newTreeInSector(sector)
    }
    
    final func newTreeInSector(sector: Int) -> GridTree<T>? {
        if sector < 4 {
            let tree = GridTree<T>(dim: leafDim, def: def)
            trees[sector] = tree
            return tree
        }
        else {
            // FIXME: throw exception
            return nil
        }
    }
}
