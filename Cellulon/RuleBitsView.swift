//
//  RuleBitsView.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-26.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit

class RuleBitsView: UIView, BitViewDelegate {
    
    @IBOutlet var bit0: BitView!
    @IBOutlet var bit1: BitView!
    @IBOutlet var bit2: BitView!
    @IBOutlet var bit3: BitView!
    @IBOutlet var bit4: BitView!
    @IBOutlet var bit5: BitView!
    @IBOutlet var bit6: BitView!
    @IBOutlet var bit7: BitView!
    @IBOutlet weak var numberLabel: UILabel!
    
    var ruleKeeper: RuleKeeper!
    
    var bitViews: [BitView] {
        return [ bit0, bit1, bit2, bit3, bit4, bit5, bit6, bit7 ]
    }
    
    var rule: UInt8 {
        get {
            var rule = UInt8(0)
            for bitView in bitViews {
                rule.updateBit(bitView.tag, value: bitView.enabled)
            }
            return rule
        }
        set(value) {
            for bitView in bitViews {
                bitView.enabled = value.bit(bitView.tag)
            }
            updateNumberText()
        }
    }
    
    override func awakeFromNib() {
        for bitView in bitViews {
            bitView.delegate = self
        }
    }
    
    func updateNumberText() {
        numberLabel.text = "\(rule)"
    }
    
    // MARK: BitViewDelegate
    
    func bitViewChanged(_ bitView: BitView) {
        updateNumberText()
        ruleKeeper.rule = rule
    }
}
