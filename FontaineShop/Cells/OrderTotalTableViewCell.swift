//
//  OrderTotalTableViewCell.swift
//  FontaineShop
//
//  Created by ANTON on 31.01.2023.
//

import UIKit

class OrderTotalTableViewCell: UITableViewCell {

    @IBOutlet weak var orderTotalLabel: UILabel!
    @IBOutlet weak var deliveryTotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var orderCoastLabel: UILabel!
    @IBOutlet weak var deliveryCoastLabel: UILabel!
    @IBOutlet weak var totalCoastLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func fill(with model: OrederTotalViewModel) {
        orderCoastLabel.text = String(model.total)
        deliveryCoastLabel.text = String(model.deliveryCoast)
        totalCoastLabel.text = String(model.total + model.deliveryCoast)
    }
    
}
