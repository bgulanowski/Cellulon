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
    
    override init(def: V) {
        values = [V](count: 100, repeatedValue: def)
        super.init(def: def)
    }
    
    override func valueAtPoint(point: GridPoint) -> V {
        return values[indexForPoint(point)]
    }
    
    override func setValue(value: V, atPoint point: GridPoint) {
        values[indexForPoint(point)] = value
    }
    
    private final func indexForPoint(point: GridPoint) -> Int {
        return point.x + point.y * 10
    }
}
