//
//  Automaton2View.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-29.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit

protocol ImageProvider {
    var image: UIImage { get }
}

class Automaton2View: UIImageView {
    
    var displayLink: CADisplayLink!
    var imageProvider: ImageProvider? {
        didSet {
            self.image = imageProvider?.image
        }
    }
    var period = 30 // the inverse of the frequency, relative to vsync
    var step = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.layer.minificationFilter = kCAFilterNearest
        displayLink = CADisplayLink(target: self, selector: "update")
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        displayLink.paused = true
    }
    
    override func startAnimating() {
        if imageProvider != nil {
            displayLink.paused = false
        }
    }
    
    override func stopAnimating() {
        displayLink.paused = true
    }
    
    func update() {
        if step == period {
            self.image = imageProvider?.image
            step = 0
        }
        else {
            ++step
        }
    }
}
