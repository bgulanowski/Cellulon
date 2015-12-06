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
        let leaf = Leaf<Int>(index: 0, def: 0, dim: 4)
        XCTAssertEqual(0,leaf.index)
    }
    
    func testValue() {
        let leaf = Leaf<Int>(index: 0, def: 99, dim: 4)
        XCTAssertEqual(99, leaf[GridPoint(n: 0)])
    }
}
