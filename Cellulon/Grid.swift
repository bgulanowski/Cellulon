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
}

public typealias GridPoint = PointI

public protocol Grid_ {
    func valueAtPoint(point: GridPoint) -> Int
    func setValue(value: Int, atPoint point: GridPoint) -> Void
}

public extension Grid_ {
    
    final func indexForPoint(point: GridPoint, dim: Int) -> Int {
        return point.y * dim + point.x
    }
    
    final func pointForIndex(index: Int, dim: Int) -> GridPoint {
        return GridPoint(x: index%dim, y: index/dim)
    }
    
    public func sectorForPoint(point: GridPoint, dim: Int) -> Int {
        return (point.x < dim ? 0 : 1) + (point.y < dim ? 0 : 2)
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
    
    public final func valueAtPoint(point: GridPoint) -> Int {
        let index = indexForPoint(point, dim: dim)
        return index < siz ? val[index] : 0
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
    let par: GridTree?
    
    init(dim: Int, par: GridTree?, lev: Int) {
        self.par = par
        self.dim = dim
        self.lev = lev
        super.init(root: nil, limbs: [Int : Grid_]())
    }
    
    convenience init(dim: Int) {
        self.init(dim: dim, par: nil, lev: 0)
    }
    
    public func offsetForIndex(index: Int) -> Int {
        return dim * dim * index
    }
    
    public func originForSector(sector: Int) -> GridPoint {
        return PointI(x: (sector & 1) * dim, y: (sector & 2) * dim)
    }
    
    public func reverseOffsetPoint(point: GridPoint) -> GridPoint {
        return point - originForSector(sectorForPoint(point, dim: dim))
    }
    
    public final func limbForPoint(point: Point<Int>) -> Grid_? {
        return limbs[indexForPoint(point, dim: dim)]
    }
}

extension GridTree : Grid_ {
    
    public final func valueAtPoint(point: Point<Int>) -> Int {
        if let limb = limbForPoint(point) {
            return limb.valueAtPoint(point)
        }
        else {
            return 0
        }
    }
    
    public final func setValue(value: Int, atPoint point: GridPoint) -> Void {
        var limb : Grid_
        if let l = limbForPoint(point) {
            limb = l
        }
        else {
            limb = newLimb()
            limbs[sectorForPoint(point, dim: dim)] = limb
        }
        limb.setValue(value, atPoint: point)
    }
    
    final func newBranch() -> GridTree {
        return GridTree(dim: dim, par: self, lev: lev-1)
    }
    
    final func newLeaf() -> Grid {
        return Grid(dim: dim)
    }
    
    final func newLimb() -> Grid_ {
        return lev == 0 ? newLeaf() : newBranch()
    }
}

public class Grove: Grid_ {
    
    let dim: Int
    var trees = [ Int : GridTree ]()
    
    init(dim: Int) {
        self.dim = dim
    }
    
    public final func valueAtPoint(point: GridPoint) -> Int {
        if let tree = trees[sectorForPoint(point)] {
            return tree.valueAtPoint(abs(point))
        }
        else {
            return 0
        }
    }
    
    public final func setValue(value: Int, atPoint point: GridPoint) -> Void {
        if let tree = trees[sectorForPoint(point)] {
            tree.setValue(value, atPoint: abs(point))
        }
    }
    
    final func sectorForPoint(point: GridPoint) -> Int {
        // treat negative values as > dim
        return sectorForPoint(point, dim: 0)
    }
    
    final func transformPoint(point: GridPoint, forSector sector: Int) -> GridPoint {
        return point * transformForSector(sector)
    }
    
    final func transformForSector(sector: Int) -> GridPoint {
        return GridPoint(x: sector & 1 == 0 ? 1 : -1, y: sector & 2 == 0 ? 1 : -1)
    }
    
    final func treeInSector(sector: Int) -> GridTree? {
        return (trees[sector] != nil) ? trees[sector] : newTreeInSector(sector)
    }
    
    final func newTreeInSector(sector: Int) -> GridTree? {
        if sector < 4 {
            let tree = GridTree(dim: dim)
            trees[sector] = tree
            return tree
        }
        else {
            // FIXME: throw exception
            return nil
        }
    }
}
