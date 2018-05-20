//
//  A1_5Cell.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-27.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit

class A1_5Cell: UICollectionViewCell {
    
    var dim = 128
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var rule: Rule = 0 {
        didSet {
            label.text = "\(rule)"
            makeImage()
        }
    }
    
    func makeImage() {
        let automaton = Automaton1_5(rule: self.rule, w: dim, h: dim)
        DispatchQueue.global(qos: .userInteractive).async { () -> Void in
            automaton[GridPoint(x: automaton.w/2, y: 0)] = true
            automaton.complete()
            let image = automaton.bitmap.image
            DispatchQueue.main.async(execute: { () -> Void in
                self.imageView.image = image
            })
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}
