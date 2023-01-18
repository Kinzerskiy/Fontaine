//
//  ProductCollectionViewCell.swift
//  FontaineShop
//
//  Created by ANTON on 11.01.2023.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    var buyComplition: (() -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }
    
    
    func fill(with model: Product)  {
        productImageView.image = UIImage(named: model.imageName)
        productNameLabel.text = model.name
        let buttonTitle = "Buy for " + "\(model.price)" + "$"
        buyButton.setTitle(buttonTitle, for: .normal)
    }
    
    func prepareUI() {
        buyButton.layer.cornerRadius = 12
    }
    
    @IBAction func buyButtonPressed(_ sender: Any) {
        buyComplition?()
    }
    
}
