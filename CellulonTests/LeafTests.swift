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
        let leaf = Leaf<Int>(index: 0, def: 0, ord: 2)
        XCTAssertEqual(0,leaf.index)
    }
    
    func testValue() {
        let leaf = Leaf<Int>(index: 0, def: 99, ord: 2)
        XCTAssertEqual(99, leaf[GridPoint(n: 0)])
    }
    
    func testBitmap() {
        let bitmap = randomLeaf().bitmap
        if let imageData = UIImagePNGRepresentation(bitmap.image) {
            saveImageData(imageData, withName: "gridImage", type: "png")
        }
    }
}

func randomLeaf() -> Leaf<Bool> {
    let leaf = Leaf<Bool>(index: 0, def: false, ord: 8)
    for _ in 1 ..< leaf.count / 10 {
        leaf.setValue(true, atPoint: GridPoint(x: random() % leaf.dim, y: random() % leaf.dim))
    }
    return leaf
}
