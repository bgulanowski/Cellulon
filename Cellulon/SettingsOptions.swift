//
//  SettingsOptions.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-26.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit

enum FirstGeneration: Int {
    case `default`
    case random
    case dots
    case dashes
}

class OptionsSection: TableSection {
    
    let firstGenRow = FirstGenRow()
    let wrapsRow = ToggleRow(title: "Wraps Edges")
    let rows: [TableRow]
    
    init() {
        rows = [firstGenRow, wrapsRow]
    }
    
    // MARK: TableSection
    
    var numberOfRows: Int {
        return 2
    }
    
    var headerTitle: String {
        return "Options"
    }
    
    var footerTitle: String {
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndex index: Int) -> UITableViewCell {
        return rows[index].cellForTableView(tableView)
    }
}

class OptionRow: TableRow {
    
    let identifier: String
    let title: String
    
    init(identifier: String, title: String) {
        self.identifier = identifier
        self.title = title
    }
    
    init(title: String) {
        self.identifier = title
        self.title = title
    }
    
    func cellForTableView(_ tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier)! as! OptionCell
        self.updateCell(cell)
        return cell
    }
    
    func updateCell(_ cell: OptionCell) {
        cell.control.addTarget(self, action: #selector(OptionRow.update(_:)), for: .valueChanged)
        cell.titleLabel!.text = title
    }
    
    @IBAction func update(_ sender: UIControl) {
        // subclasses will override
    }
}

class FirstGenRow: OptionRow {
    
    var value = FirstGeneration.default
    
    init() {
        super.init(identifier: "First Generation", title: "Gen 0")
    }
    
    override func updateCell(_ cell: OptionCell) {
        super.updateCell(cell)
        (cell.control as! UISegmentedControl).selectedSegmentIndex = value.rawValue
    }
    
    @IBAction override func update(_ sender: UIControl) {
        if let newValue = FirstGeneration(rawValue: (sender as! UISegmentedControl).selectedSegmentIndex) {
            value = newValue
        }
    }
}

class ToggleRow: OptionRow {
    
    var value = false
    
    override init(title: String) {
        super.init(identifier: "Toggle", title: title)
    }
    
    override func updateCell(_ cell: OptionCell) {
        super.updateCell(cell)
        (cell.control as! UISwitch).isOn = value
    }
}

class OptionCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var control: UIControl!
}
