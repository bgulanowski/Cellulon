//
//  Grid.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

public typealias GridPoint = PointI

public class Grid<V> {
    
    let def: V
    let dim: Int
    
    init(def: V, dim: Int) {
        self.def = def
        self.dim = dim
    }
    
    func valueAtPoint(point: GridPoint) -> V {
        return def
    }
    
    func setValue(value: V, atPoint point: GridPoint) -> Void {
    }
}

extension Grid {
    subscript(index: GridPoint) -> V {
        get {
            return valueAtPoint(index)
        }
        set {
            setValue(newValue, atPoint: index)
        }
    }
}
