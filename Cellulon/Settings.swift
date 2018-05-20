//
//  Settings.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-23.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit

class Settings: UIViewController, UINavigationBarDelegate, UITableViewDelegate, RuleKeeper {
    
    var rule: UInt8 = 113 {
        didSet {
            if ruleBitsView != nil {
                ruleBitsView.rule = rule
            }
            tableView?.reloadSections(IndexSet(integer: 0), with: .none)
        }
    }
    
    var firstGeneration: FirstGeneration {
        get {
            return optionsSection.firstGenRow.value
        }
        set(newValue) {
            optionsSection.firstGenRow.value = newValue
        }
    }
    
    var table: Table = Table()
    var ruleSection: RuleBitsSection!
    var patternsSection: PatternsSection!
    var optionsSection: OptionsSection!
    
    var ruleBitsView: RuleBitsView!

    @IBOutlet weak var tableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ruleSection = RuleBitsSection()
        patternsSection = PatternsSection(ruleKeeper: self)
        optionsSection = OptionsSection()
        table.sections = [ ruleSection, patternsSection, optionsSection ]
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        loadRuleBits()
        tableView.delegate = self
        tableView.dataSource = table
    }
    
    func loadRuleBits() {
        let nib = UINib(nibName: "RuleBitsView", bundle: nil)
        ruleBitsView = nib.instantiate(withOwner: nil, options: nil).first as! RuleBitsView
        ruleBitsView.ruleKeeper = self
        ruleBitsView.rule = rule
    }
    
    // MARK: UINavigationBarDelegate
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 66 : tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? ruleBitsView : nil
    }
    
    // MARK: Actions
    
    @IBAction func dismiss() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
