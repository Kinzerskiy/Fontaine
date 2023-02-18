//
//  PreviousOrdersTableViewCell.swift
//  FontaineShop
//
//  Created by ANTON on 17.02.2023.
//

import UIKit

class PreviousOrdersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderInfoLable: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func fill(with model: Order) {
        orderInfoLable.text = "\(model.orderId)" + " " + "\(model.deliveryTime)"
    }
    
    @IBAction func checkOrderButton(_ sender: Any) {
        
    }
}
