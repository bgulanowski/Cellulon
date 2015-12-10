//
//  Tree.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

public class TreeSupport {
    static var serialQueue = dispatch_queue_create("Tree", DISPATCH_QUEUE_SERIAL)
}

public class Tree<V> : Branch<V> {
    
    override public func valueAtPoint(point: GridPoint) -> V {
        return super.valueAtPoint(transformedPoint(point))
    }
    
    override public func setValue(value: V, atPoint point: GridPoint) {
        super.setValue(value, atPoint: transformedPoint(point))
    }
    
    override func sectorForPoint(point: GridPoint) -> Sector {
        return Sector.sectorForPoint(point)!
    }
    
    func transformedPoint(point: GridPoint) -> GridPoint {
        return abs(point)
    }
    
    func expandSector(sector: Sector) -> Void {
        
    }
    
    
}

/*
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
*/