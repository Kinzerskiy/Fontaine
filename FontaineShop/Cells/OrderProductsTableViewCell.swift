//
//  OrderProductsTableViewCell.swift
//  FontaineShop
//
//  Created by ANTON on 20.02.2023.
//

import UIKit

class OrderProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fill(with model: BasketProduct) {
        productNameLabel.text = model.product.name
        countLabel.text = String(model.count)
        totalPriceLabel.text = String(Double(model.count) * model.product.price)
    }
    
}
