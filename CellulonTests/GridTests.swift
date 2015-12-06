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

    func testBasicGridAccess() {
        let grid = BasicGrid<Int>(def: 0, dim: 8)
        let point = GridPoint(x: 4, y: 4)
        grid.setValue(100, atPoint: point)
        XCTAssertEqual(grid.valueAtPoint(point), 100)
    }
    
    func testBasicGridSubscripting() {
        let grid = BasicGrid<Int>(def: 0, dim: 8)
        let point = GridPoint(x: 4, y: 4)
        grid[point] = 100
        XCTAssertEqual(grid[point], 100)
    }

    /*
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }*/

}
