//
//  Leaf.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

public class Leaf<V:ColorConvertable> : BasicGrid<V> {
    
    public var index: Int
    
    public var bitmap: Bitmap {
        return Bitmap(grid: self)
    }
    
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

extension Bitmap {
    
    public convenience init<V:ColorConvertable>(grid: Grid<V>) {
        self.init(size: CGSizeMake(CGFloat(grid.dim), CGFloat(grid.dim)), color: ColorFromCGColor(UIColor.whiteColor().CGColor))
        for i in 0 ..< grid.dim {
            for j in 0 ..< grid.dim {
                let point = GridPoint(x: i, y: j)
                setColor(grid.valueAtPoint(point).color, atPoint: CGPoint(x: i, y: j))
            }
        }
    }
}
