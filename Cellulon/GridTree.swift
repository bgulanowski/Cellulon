//
//  GridTree.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

public class GridTree<T:PointSubscriptable> : Tree<T> {
    
    public typealias ValueType = T.ValueType
    
    let dim: Int
    let lev: Int
    let def: T.ValueType
    
    init(root: GridTree?, dim: Int, lev: Int, def: ValueType) {
        self.dim = dim
        self.lev = lev
        self.def = def
        super.init(root: root, limbs: [Int : T]())
    }
    
    convenience init(dim: Int, def: ValueType) {
        self.init(root: nil, dim: dim, lev: 0, def: def)
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
        return GridTree<T>(root: self, dim: dim, lev: lev-1, def: def)
    }
    
    final func newLeaf() -> Grid<T.ValueType> {
        return Grid<T.ValueType>(dim: dim, def: def)
    }
    
    final func newLimb() -> T {
        // FIXME: there is a property type that both GridTree<T> and Grid<T.ValueType> conform to?
        return lev == 0 ? newLeaf() as! T : newBranch() as! T
    }
}
