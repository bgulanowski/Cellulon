//
//  GridTests.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-06.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import XCTest
import Cellulon

class GridTests: XCTestCase {
    
    func testGridDefault() {
        let grid = Grid<Int>(def: -1, pow: 1)
        let min = grid.min()
        let max = grid.max()
        XCTAssertTrue(PointI(n: 0) == min)
        XCTAssertTrue(PointI(n: 1) == max)
        XCTAssertEqual(-1, grid.valueAtPoint(min))
        XCTAssertEqual(-1, grid.valueAtPoint(max))
    }
    
    func testGridIndexConversion() {
        let grid = Grid<Int>(def: 0, pow: 3)
        var point = GridPoint(x: 0, y: 0)
        XCTAssertTrue(point == grid.pointForIndex(0))
        XCTAssertEqual(0, grid.indexForPoint(point))
        
        point = GridPoint(x: 7, y: 0)
        XCTAssertTrue(point == grid.pointForIndex(7))
        XCTAssertEqual(7, grid.indexForPoint(point))
        
        point = GridPoint(x: 0, y: 7)
        XCTAssertTrue(point == grid.pointForIndex(56))
        XCTAssertEqual(56, grid.indexForPoint(point))
        
        point = GridPoint(x: 7, y: 7)
        XCTAssertTrue(point == grid.pointForIndex(63))
        XCTAssertEqual(63, grid.indexForPoint(point))
    }

    func testBasicGridAccess() {
        let grid = BasicIntGrid(def: 0, pow: 3)
        let point = GridPoint(x: 4, y: 4)
        grid.setValue(100, atPoint: point)
        XCTAssertEqual(grid.valueAtPoint(point), 100)
    }
    
    func testBasicGridSubscripting() {
        let grid = BasicIntGrid(def: 0, pow: 3)
        let point = GridPoint(x: 4, y: 4)
        grid[point] = 100
        XCTAssertEqual(grid[point], 100)
    }
}
