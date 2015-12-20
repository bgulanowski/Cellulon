//
//  BitmapTests.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-19.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import XCTest
import Cellulon

class BitmapTests: XCTestCase {

    func testColorFromWhite() {
        let uiColor = UIColor.whiteColor()
        let cgColor = uiColor.CGColor
        let actual = ColorFromCGColor(cgColor)
        XCTAssertEqual(actual.v, UINT32_MAX, "color was not opaque pure white")
    }
    
    func testColorFromMustardYellow() {
        let comps: [CGFloat] = [ 0.5, 0.5, 0, 1.0 ]
        let space = CGColorSpaceCreateDeviceRGB()
        let cgColor = CGColorCreate(space, comps)!
        let actual = ColorFromCGColor(cgColor)
        XCTAssertEqual(actual.v, NSSwapBigIntToHost(0x7F7F00FF), "color was not opaque mustard yellow")
    }
    
    func testColorToGrey() {
        let color = Color(c: Components(r: 127, g: 127, b: 127, a: 255))
        let cgColor = ColorToCGColor(color).takeUnretainedValue()
        XCTAssertEqual(CGColorGetNumberOfComponents(cgColor), 4, "color had wrong number of components")
        let comps = CGColorGetComponents(cgColor)
        let actual = [ comps[0], comps[1], comps[2], comps[3] ]
        let expected: [CGFloat] = [ 0.5, 0.5, 0.5, 1.0 ]
        XCTAssertEqual(actual, expected, "color had wrong components")
    }

    func test() {
        let bitmap = Bitmap(size: CGSizeMake(128, 128), CGColor: UIColor.whiteColor().CGColor)
        let whiteColor = Color(c: Components(r: 255, g: 255, b: 255, a: 255))
        XCTAssertEqual(bitmap.colorAtPoint(CGPointMake(127, 127)).v, whiteColor.v)
    }
}
