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
        let branch = Branch(def: 0, ord: 0)
        XCTAssertEqual(0, branch.indexForPoint(GridPoint(x: 0, y: 0)))
    }
    
    func testBranchPointToIndex1_1() {
        let branch = Branch(def: 0, ord: 0)
        XCTAssertEqual(1, branch.indexForPoint(GridPoint(x: 1, y: 0)))
        XCTAssertEqual(2, branch.indexForPoint(GridPoint(x: 0, y: 1)))
        XCTAssertEqual(3, branch.indexForPoint(GridPoint(x: 1, y: 1)))
    }
    
    func testBranchPointToIndex1_2() {
        let branch = Branch(def: 0, ord: 0)
        XCTAssertEqual(5, branch.indexForPoint(GridPoint(x: 3, y: 0)))
        XCTAssertEqual(10, branch.indexForPoint(GridPoint(x: 0, y: 3)))
        XCTAssertEqual(15, branch.indexForPoint(GridPoint(x: 3, y: 3)))
    }
    
    func testBranchToPointIndex2_0() {
        let branch = Branch(def: 0, ord: 1)
        XCTAssertEqual(0, branch.indexForPoint(GridPoint(x: 0, y: 0)))
        XCTAssertEqual(1, branch.indexForPoint(GridPoint(x: 1, y: 0)))
        XCTAssertEqual(2, branch.indexForPoint(GridPoint(x: 0, y: 1)))
        XCTAssertEqual(3, branch.indexForPoint(GridPoint(x: 1, y: 1)))
    }
    
    func testBranchToPointIndex2_1() {
        let branch = Branch(def: 0, ord: 1)
        // Different leaf size, same layout as dim = 1, because 2x2 = 2+2?
        XCTAssertEqual(5, branch.indexForPoint(GridPoint(x: 3, y: 0)))
        XCTAssertEqual(10, branch.indexForPoint(GridPoint(x: 0, y: 3)))
        XCTAssertEqual(15, branch.indexForPoint(GridPoint(x: 3, y: 3)))
    }
    
    func testBranchToPointIndex4_1() {
        let branch = Branch(def: 0, ord: 2)
        // Different leaf size, same layout as dim = 1, because 2x2 = 2+2?
        XCTAssertEqual(3, branch.indexForPoint(GridPoint(x: 3, y: 0)))
         XCTAssertEqual(12, branch.indexForPoint(GridPoint(x: 0, y: 3)))
        XCTAssertEqual(15, branch.indexForPoint(GridPoint(x: 3, y: 3)))
    }
    
    func testBranchSet() {
        let branch = Branch(def: 0, ord: 7, lev: 2, idx: 0, root: nil)
        let expectation = self.expectation(description: "hi")
        branch.onBuild = { _, _ in
            expectation.fulfill()
        }
        
        let p = GridPoint(x: 127, y: 127)
        branch.setValue(1, atPoint: p)
        XCTAssertEqual(branch.valueAtPoint(p), 1)
        self.waitForExpectations(timeout: 0.5, handler: nil)
    }
}
