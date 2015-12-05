//
//  Grid.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-11-29.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

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
