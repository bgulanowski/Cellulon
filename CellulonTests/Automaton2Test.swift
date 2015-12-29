//
//  Automaton2Test.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-28.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import XCTest
import Cellulon

class Automaton2Test: XCTestCase {
    
    var automaton: Automaton2!
    
    override func setUp() {
        super.setUp()
        automaton = Automaton2(w: 32, h: 32)
    }
    
    override func tearDown() {
        automaton = nil
        super.tearDown()
    }
    
    func testMakeImage() {
        automaton.populate()
        let image = automaton.bitmap.image
        XCTAssertNotNil( image )
        XCTAssertTrue(CGSizeEqualToSize(image.size, CGSize(width: 32, height: 32)))
    }
    
    func testUpdate() {
        
        automaton.makeBlockWithSize(GridSize(x: 2, y: 2), offset: GridPoint(x: 0, y: 0))
        
        automaton.makeBeaconWithOffset(GridPoint(x: 0, y: 16))
        
        automaton.makePulsarWithOffset(GridPoint(x: 16, y: 16))

        automaton.makeGliderWithOffset(GridPoint(x: 13, y: 13))
        
        for i in 0 ..< 4 {
            let image = automaton.bitmap.image
            if let actual = UIImagePNGRepresentation(image) {
                let imageName = "automaton2TestImage_\(i)", filetype = "png"
                if let expected = loadDataForImageNamed(imageName, type: filetype) {
                    XCTAssertEqual(actual, expected)
                }
                else {
                    saveImageData(actual, withName: imageName, type: filetype)
                }
            }
            automaton.update()
        }
    }
}

extension Automaton2 {
    
    // each design includes a 1-point border
    
    func makeBlockWithSize(size: GridSize, offset: GridPoint) {
        for i in 1 + offset.x ..< 1 + size.x + offset.x {
            for j in 1 + offset.y ..< 1 + size.y + offset.y {
                self[GridPoint(x: i, y: j)] = true
            }
        }
    }
    
    func makeBeaconWithOffset(offset: GridPoint) {
        self.makeBlockWithSize(GridSize(w: 2, h: 2), offset: offset)
        self.makeBlockWithSize(GridSize(w: 2, h: 2), offset: offset + GridPoint(x: 2, y: 2))
    }
    
    func makeGliderWithOffset(offset: GridPoint) {
        self[GridPoint(x: 1, y: 1) + offset] = true
        self[GridPoint(x: 2, y: 1) + offset] = true
        self[GridPoint(x: 3, y: 1) + offset] = true
        self[GridPoint(x: 3, y: 2) + offset] = true
        self[GridPoint(x: 2, y: 3) + offset] = true
    }
    
    func makePulsarWithOffset(offset: GridPoint) {
        
        // Quadrant 1
        makeHorizontalLine(GridPoint(x: 3, y: 1) + offset, length: 3)
        makeHorizontalLine(GridPoint(x: 3, y: 6) + offset, length: 3)
        makeVerticalLine(GridPoint(x: 1, y: 3) + offset, length: 3)
        makeVerticalLine(GridPoint(x: 6, y: 3) + offset, length: 3)
        
        // Quadrant 2
        makeHorizontalLine(GridPoint(x: 9, y: 1) + offset, length: 3)
        makeHorizontalLine(GridPoint(x: 9, y: 6) + offset, length: 3)
        makeVerticalLine(GridPoint(x:  8, y: 3) + offset, length: 3)
        makeVerticalLine(GridPoint(x: 13, y: 3) + offset, length: 3)
        
        // Quadrant 3
        makeHorizontalLine(GridPoint(x: 3, y:  8) + offset, length: 3)
        makeHorizontalLine(GridPoint(x: 3, y: 13) + offset, length: 3)
        makeVerticalLine(GridPoint(x: 1, y: 9) + offset, length: 3)
        makeVerticalLine(GridPoint(x: 6, y: 9) + offset, length: 3)
        
        // Quadrant 4
        makeHorizontalLine(GridPoint(x: 9, y: 8) + offset, length: 3)
        makeHorizontalLine(GridPoint(x: 9, y: 13) + offset, length: 3)
        makeVerticalLine(GridPoint(x: 8, y: 9) + offset, length: 3)
        makeVerticalLine(GridPoint(x: 13, y: 9) + offset, length: 3)
    }
    
    // Not in the mood to implement Bresenham's for 3 pixels
//    func makeLineWithStart(start: GridPoint, end: GridPoint) {
//        let dX = end.x - start.x
//        let dY = end.y - start.y
//        
//    }
    
    func makeVerticalLine(start: GridPoint, length: Int) {
        for i in 0 ..< length {
            self[start + GridPoint(x: 0, y: i)] = true
        }
    }
    
    func makeHorizontalLine(start: GridPoint, length: Int) {
        for i in 0 ..< length {
        self[start + GridPoint(x: i, y: 0)] = true
        }
    }
}
