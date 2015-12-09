//
//  Leaf.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

public class Leaf<V> : BasicGrid<V> {
    
    public var index: Int
    
    public init(index: Int, def: V, pow: Int) {
        self.index = index
        let values = Leaf.loadValues(index, def: def, count: areaForPower(pow))
        super.init(def: def, pow: pow, values: values)
    }
    
    static func loadValues(index: Int, def: V, count: Int) -> [V] {
        // TODO: load from storage
        return [V](count: count, repeatedValue: def)
    }
    
    static func storeValues(leaf: Leaf) -> Void {
        // TODO:
    }
}
