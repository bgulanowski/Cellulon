//
//  PatternCell.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-26.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit

class PatternCell: UITableViewCell {
    
    var ruleKeeper: RuleKeeper!
    
    @IBOutlet var bit0View: BitView!
    @IBOutlet var bit1View: BitView!
    @IBOutlet var bit2View: BitView!
    
    @IBOutlet var label: UILabel!
    @IBOutlet var enabledSwitch: UISwitch!
    
    var number: Int = 0 {
        didSet {
            label.text = "\(number)"
            enabledSwitch.isOn = ruleKeeper.rule.bit(number)
            bit0View.enabled = (number & 1 == 1)
            bit1View.enabled = (number & 2 == 2)
            bit2View.enabled = (number & 4 == 4)
        }
    }
    
    @IBAction func updateEnabled(_ sender: UISwitch) {
        var rule = ruleKeeper.rule
        if sender.isOn {
            rule.setBit(number)
        }
        else {
            rule.clearBit(number)
        }
        ruleKeeper!.rule = rule
    }
}
