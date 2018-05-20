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
        self.layer.magnificationFilter = kCAFilterNearest
        displayLink = CADisplayLink(target: self, selector: #selector(Automaton2View.update))
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        displayLink.isPaused = true
    }
    
    override func startAnimating() {
        if imageProvider != nil {
            displayLink.isPaused = false
        }
    }
    
    override func stopAnimating() {
        displayLink.isPaused = true
    }
    
    func update() {
        if step == period {
            self.image = imageProvider?.image
            step = 0
        }
        else {
            step += 1
        }
    }
}
