//
//  Leaf.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

public class Leaf<V:ColorConvertible> : BasicGrid<V> {
    
    public var index: Int
    
    public init(index: Int, def: V, ord: Int) {
        self.index = index
        let values = Leaf.loadValues(index, def: def, count: areaForOrder(ord))
        super.init(def: def, ord: ord, values: values)
    }
    
    static func loadValues(index: Int, def: V, count: Int) -> [V] {
        // TODO: load from storage
        return [V](count: count, repeatedValue: def)
    }
    
    static func storeValues(leaf: Leaf) -> Void {
        // TODO:
    }
}
