//
//  PointTests.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-06.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import XCTest
import Cellulon

class PointTests: XCTestCase {
    
    var p1 = PointI(x: 0, y: 0)
    var p2 = PointI(x: 1, y: 2)
    var p3 = PointI(n: 3)
    
    func testAddition() {
        XCTAssertTrue(p2 == p1 + p2)
        XCTAssertTrue(p2 + PointI(x: 2, y: 1) == p3)
    }
    
    func testUnaryMinus() {
        XCTAssertTrue(PointI(x: -1, y: -2) == -p2)
    }
    
    func testSubtraction() {
        XCTAssertTrue(PointI(n: -3) == -p3)
    }
    
    func testComponentMultiplication() {
        XCTAssertTrue((p1 * p2) == p1)
        XCTAssertTrue(p1 == (p1 * p2))
        XCTAssertTrue(PointI(n: 1) * p3 == p3)
        XCTAssertTrue(p2 * p3 == PointI(x: 3, y: 6))
    }
    
    func testScalarMultiplication() {
        XCTAssertTrue(PointI(n: 1) * 3 == p3)
        XCTAssertTrue(3 * p2 == PointI(x: 3, y: 6))
    }
    
    func testAbsoluteValue() {
        XCTAssertTrue(abs(PointI(x: -1, y: -2)) == p2)
    }
}
