//
//  Automaton2VC.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-26.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit

class Automaton2VC: UIViewController, ImageProvider {

    var automaton: Automaton2!
    var firstAppearance = true
    
    @IBOutlet var automatonView: Automaton2View!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstAppearance {
            createAutomaton()
            firstAppearance = false
        }
        automatonView.startAnimating()
    }
    
    override func viewWillDisappear(animated: Bool) {
        automatonView.stopAnimating()
    }
    
    var image: UIImage {
        automaton.update()
        return automaton.bitmap.image
    }
    
    func createAutomaton() {
        var size = view.bounds.size.gridSize
        if size.w > 256 {
            size /= 3
        }
        else {
            size /= 2
        }
        automaton = Automaton2(w:size.w, h:size.h)
        automaton.populate()

        automatonView.period = 6
        automatonView.imageProvider = self
    }
}
