//
//  LeafTests.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-06.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import XCTest
import Cellulon

class LeafTests: XCTestCase {
    func testIndex() {
        let leaf = Leaf<Int>(index: 0, def: 0, pow: 2)
        XCTAssertEqual(0,leaf.index)
    }
    
    func testValue() {
        let leaf = Leaf<Int>(index: 0, def: 99, pow: 2)
        XCTAssertEqual(99, leaf[GridPoint(n: 0)])
    }
}
