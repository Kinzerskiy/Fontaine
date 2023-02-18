//
//  PaymentMethodTableViewCell.swift
//  FontaineShop
//
//  Created by ANTON on 12.02.2023.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var paymentCompletion: ((PaymentMethod) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func suitDidChange(_ sender: UISegmentedControl) {
        guard let paymentMethod = PaymentMethod(rawValue: segmentControl.selectedSegmentIndex) else { return }
        paymentCompletion?(paymentMethod)
    }
    
    func fill(with model: PaymentCellViewModel) {
        segmentControl.selectedSegmentIndex = model.value.rawValue
        paymentCompletion = model.completion
    }
}
