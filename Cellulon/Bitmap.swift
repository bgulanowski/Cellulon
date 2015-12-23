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
    public var cgSize: CGSize {
        return CGSize(width: width, height: height)
    }
    public var bitmap: Bitmap {
        return Bitmap(grid: self)
    }
}

extension Bitmap {
    public convenience init<V:ColorConvertible>(grid: Grid<V>) {
        self.init(size: grid.cgSize, color: ColorFromCGColor(UIColor.whiteColor().CGColor))
        for i in 0 ..< grid.width {
            for j in 0 ..< grid.height {
                let point = GridPoint(x: i, y: j)
                setColor(grid.valueAtPoint(point).color, atPoint: CGPoint(x: i, y: j))
            }
        }
    }
}
