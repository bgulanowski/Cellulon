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
    
    init(def: V) {
        self.def = def
    }
    
    func valueAtPoint(point: GridPoint) -> V {
        return def
    }
    
    func setValue(value: V, atPoint point: GridPoint) -> Void {
    }
}
