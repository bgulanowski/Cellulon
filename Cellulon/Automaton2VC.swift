//
//  Automaton2VC.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-26.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit

class Automaton2VC: UIViewController, ImageProvider {

    var automaton = Automaton2(def: false, ord: 8)
    
    @IBOutlet var automatonView: Automaton2View!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automatonView.period = 6
        automatonView.imageProvider = self
        automaton.populate()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        automatonView.startAnimating()
    }
    
    override func viewWillDisappear(animated: Bool) {
        automatonView.stopAnimating()
    }
    
    var image: UIImage {
        automaton.update()
        return automaton.bitmap.image
    }
}
