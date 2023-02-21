//
//  OrderTableViewCell.swift
//  FontaineShop
//
//  Created by ANTON on 20.02.2023.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var paymentStatusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fill(with order: Order?) {
        guard let order = order else { return }
        orderIdLabel.text = order.orderId
        dateLabel.text = "\(order.orderCreated)"
        addressLabel.text = order.address
        if order.paymentCompleted == false {
            paymentStatusLabel.text = "❌Payment does not completed"
        } else {
            paymentStatusLabel.text = "✅Payment completed"
        }
    }
    
}
