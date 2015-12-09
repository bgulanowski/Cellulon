//
//  BranchTests.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-06.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import XCTest
import Cellulon

class BranchTests: XCTestCase {
    
    func testBranchPointToIndex1_0() {
        let branch = Branch(def: 0, pow: 0, lev: 0, root: nil)
        XCTAssertEqual(0, branch.indexForPoint(GridPoint(x: 0, y: 0)))
    }
    
    func testBranchPointToIndex1_1() {
        let branch = Branch(def: 0, pow: 0, lev: 1, root: nil)
        XCTAssertEqual(1, branch.indexForPoint(GridPoint(x: 1, y: 0)))
        XCTAssertEqual(2, branch.indexForPoint(GridPoint(x: 0, y: 1)))
        XCTAssertEqual(3, branch.indexForPoint(GridPoint(x: 1, y: 1)))
    }
    
    func testBranchPointToIndex1_2() {
        let branch = Branch(def: 0, pow: 0, lev: 2, root: nil)
        XCTAssertEqual(5, branch.indexForPoint(GridPoint(x: 3, y: 0)))
        XCTAssertEqual(10, branch.indexForPoint(GridPoint(x: 0, y: 3)))
        XCTAssertEqual(15, branch.indexForPoint(GridPoint(x: 3, y: 3)))
    }
    
    func testBranchToPointIndex2_0() {
        let branch = Branch(def: 0, pow: 1, lev: 0, root: nil)
        XCTAssertEqual(0, branch.indexForPoint(GridPoint(x: 0, y: 0)))
        XCTAssertEqual(1, branch.indexForPoint(GridPoint(x: 1, y: 0)))
        XCTAssertEqual(2, branch.indexForPoint(GridPoint(x: 0, y: 1)))
        XCTAssertEqual(3, branch.indexForPoint(GridPoint(x: 1, y: 1)))
    }
    
    func testBranchToPointIndex2_1() {
        let branch = Branch(def: 0, pow: 1, lev: 1, root: nil)
        // Different leaf size, same layout as dim = 1, because 2x2 = 2+2?
        XCTAssertEqual(5, branch.indexForPoint(GridPoint(x: 3, y: 0)))
        XCTAssertEqual(10, branch.indexForPoint(GridPoint(x: 0, y: 3)))
        XCTAssertEqual(15, branch.indexForPoint(GridPoint(x: 3, y: 3)))
    }
    
    func testBranchToPointIndex4_1() {
        let branch = Branch(def: 0, pow: 2, lev: 1, root: nil)
        // Different leaf size, same layout as dim = 1, because 2x2 = 2+2?
        XCTAssertEqual(3, branch.indexForPoint(GridPoint(x: 3, y: 0)))
        XCTAssertEqual(12, branch.indexForPoint(GridPoint(x: 0, y: 3)))
        XCTAssertEqual(15, branch.indexForPoint(GridPoint(x: 3, y: 3)))
    }
}
