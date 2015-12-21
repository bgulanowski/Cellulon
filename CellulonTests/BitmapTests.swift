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

    func testBitmapGetColor() {
        let bitmap = Bitmap(size: CGSizeMake(128, 128), CGColor: UIColor.whiteColor().CGColor)
        let whiteColor = Color(c: Components(r: 255, g: 255, b: 255, a: 255))
        XCTAssertEqual(bitmap.colorAtPoint(CGPointMake(127, 127)).v, whiteColor.v)
    }
    
    func testBitmapGetImage() {
        
        if let actual = UIImagePNGRepresentation(Bitmap.sampleBitmap().image) {
            let imageName = "bitmapTestImage", filetype = "png"
            if let expected = loadDataForImageNamed(imageName, type: filetype) {
                XCTAssertEqual(actual, expected)
            }
            else {
                saveImageData(actual, withName: imageName, type: filetype)
            }
        }
    }
}

public func loadDataForImageNamed(name: String, type: String) -> NSData? {
    let bundle = NSBundle(forClass: BitmapTests.self)
    if let url = bundle.URLForResource(name, withExtension: type) {
        return NSData(contentsOfURL: url)
    }
    else {
        return nil
    }
}

public func saveImageData(data: NSData, withName name: String, type: String) {
    let url = NSURL(fileURLWithPath: NSString(string: "~/Documents/\(name).\(type)").stringByExpandingTildeInPath)
    data.writeToURL(url, atomically: true)
    print("test image file has been saved to \(url); copy into bundle")
}

extension Bitmap {
    static func sampleBitmap() -> Bitmap {
    
        let bitmap = Bitmap(size: CGSizeMake(128, 128), CGColor: UIColor.blackColor().CGColor)
        let borderColor = UIColor.redColor().CGColor
        let diagonalColor = UIColor.blueColor().CGColor
        let checkColor = UIColor.whiteColor().CGColor
        
        for i in 0 ..< 127 {
            for j in 0 ..< 127 {
                if i == 0 || i == 127 || j == 0 || j == 127 {
                    bitmap.setCGColor(borderColor, atPoint: CGPointMake(CGFloat(i), CGFloat(j)))
                }
                else if i == j || i + j == 127 {
                    bitmap.setCGColor(diagonalColor, atPoint: CGPointMake(CGFloat(i), CGFloat(j)))
                }
                else if (i+j) % 2 == 0 {
                    bitmap.setCGColor(checkColor, atPoint: CGPointMake(CGFloat(i), CGFloat(j)))
                }
            }
        }
        return bitmap
    }
}
