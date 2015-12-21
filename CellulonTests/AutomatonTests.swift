//
//  AutomatonTests.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-21.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import XCTest
import Cellulon

func ==<T1: Equatable, T2: Equatable>(lhs: (T1,T2), rhs: (T1,T2)) -> Bool {
    return lhs.0 == rhs.0 && lhs.1 == rhs.1
}

class AutomatonTests: XCTestCase {

    func testLogNextPowerOf2() {
        
        let vals = [ 1:(1,2), 2:(2,4), 7:(3,8), 8:(4,16), 9:(4,16)]
        
        for (val, expected) in vals {
            let (e1, e2) = expected
            let (a1, a2) = nextPowerOf2Log(val)
            XCTAssertEqual(a1, e1)
            XCTAssertEqual(a2, e2)
        }
    }
}
