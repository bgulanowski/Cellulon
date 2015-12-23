//
//  Bitmap.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-22.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

/*
 * The Bitmap class is found in Bitmap.h.
 */

public extension Grid {
    public var bitmap: Bitmap {
        return Bitmap(grid: self)
    }
}

extension Bitmap {
    public convenience init<V:ColorConvertible>(grid: Grid<V>) {
        self.init(size: CGSizeMake(CGFloat(grid.dim), CGFloat(grid.dim)), color: ColorFromCGColor(UIColor.whiteColor().CGColor))
        for i in 0 ..< grid.dim {
            for j in 0 ..< grid.dim {
                let point = GridPoint(x: i, y: j)
                setColor(grid.valueAtPoint(point).color, atPoint: CGPoint(x: i, y: j))
            }
        }
    }

    convenience init(automaton: Automaton1_5) {
        self.init(size: automaton.cgSize, color: opaqueWhite)
        for i in 0 ..< automaton.w {
            for j in 0 ..< automaton.h {
                let point = GridPoint(x: i, y: j)
                setColor(automaton.valueAtPoint(point).color, atPoint: CGPoint(x: i, y: j))
            }
        }
    }
}
