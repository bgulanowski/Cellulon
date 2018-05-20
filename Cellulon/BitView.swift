//
//  BitView.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-26.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit

let borderColor = UIColor.gray

protocol BitViewDelegate {
    func bitViewChanged(_ bitView: BitView)
}

class BitView : UIView {
    
    var delegate: BitViewDelegate? {
        didSet {
            if delegate != nil {
                self.isUserInteractionEnabled = true
                tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(BitView.didTap(_:)))
                self.addGestureRecognizer(tapRecognizer!)
            }
            else if delegate == nil {
                self.isUserInteractionEnabled = false
                if tapRecognizer != nil {
                    self.removeGestureRecognizer(tapRecognizer!)
                    tapRecognizer = nil
                }
            }
        }
    }
    
    var tapRecognizer: UITapGestureRecognizer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureBit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBit()
    }
    
    func configureBit() {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 1.0
    }
    
    var enabled: Bool = false {
        didSet {
            updateEnabled()
        }
    }
    
    func updateEnabled() {
        if enabled {
            enable()
        }
        else {
            disable()
        }
    }
    
    func enable() {
        self.backgroundColor = borderColor
    }
    
    func disable() {
        self.backgroundColor = UIColor.white
    }
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        enabled = !enabled
        delegate?.bitViewChanged(self)
    }
}
