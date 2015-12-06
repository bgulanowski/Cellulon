//
//  Leaf.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

public class Leaf<V> : Grid<V> {
    
    var values: [V]
    var index: Int
    
    required public init(index: Int, def: V, dim: Int) {
        self.index = index
        values = Leaf.loadValues(index, def: def, dim: dim)
        super.init(def: def, dim: dim)
    }
    
    override func valueAtPoint(point: GridPoint) -> V {
        return values[indexForPoint(point)]
    }
    
    override func setValue(value: V, atPoint point: GridPoint) {
        values[indexForPoint(point)] = value
    }
    
    static func loadValues(index: Int, def: V, dim: Int) -> [V] {
        // TODO: load from storage
        return [V](count: dim * dim, repeatedValue: def)
    }
    
    static func storeValues(leaf: Leaf) -> Void {
        // TODO:
    }
}
