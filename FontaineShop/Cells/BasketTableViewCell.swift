//
//  BasketTableViewCell.swift
//  FontaineShop
//
//  Created by ANTON on 11.01.2023.
//

import UIKit

class BasketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    var addCompletion: (() -> Void)?
    var removeCompletion: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
    }
    
    func fill(with model: BasketProduct) {
        productImage.image = UIImage(named: model.product.imageName)
        productName.text = model.product.name
        counterLabel.text = "\(model.count)"
    }
    
    @IBAction func moreProduct(_ sender: Any) {
        addCompletion?()
    }
    
    @IBAction func lessProduct(_ sender: Any) {
        removeCompletion?()
    }
}
