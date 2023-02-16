//
//  SwitcherTableViewCell.swift
//  FontaineShop
//
//  Created by ANTON on 31.01.2023.
//

import UIKit

class SwitcherTableViewCell: UITableViewCell {

    @IBOutlet weak var infoTextLabel: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    
    var switchCompletion: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
      
    }
    
    func fill(with model: SwitcherCellViewModel) {
        infoTextLabel.text = model.switcherName
        switchView.isOn = model.isOn
        switchCompletion = model.completion
    }
    
    @IBAction func switcherValueDidChange(_ sender: Any) {
        switchCompletion?(switchView.isOn)
    }
    
}
