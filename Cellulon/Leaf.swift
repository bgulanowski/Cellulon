//
//  Leaf.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

public class Leaf<V> : BasicGrid<V> {
    
    var index: Int
    
    required public init(index: Int, def: V, dim: Int) {
        self.index = index
        let values = Leaf.loadValues(index, def: def, dim: dim)
        super.init(def: def, dim: dim, values: values)
    }
    
    static func loadValues(index: Int, def: V, dim: Int) -> [V] {
        // TODO: load from storage
        return [V](count: dim * dim, repeatedValue: def)
    }
    
    static func storeValues(leaf: Leaf) -> Void {
        // TODO:
    }
}
