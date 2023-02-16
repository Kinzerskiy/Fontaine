//
//  TextFieldTableViewCell.swift
//  FontaineShop
//
//  Created by ANTON on 31.01.2023.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var labelName: UILabel!
    
    var infoCompletion: ((String) -> Void)?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addressTextField.delegate = self
        selectionStyle = .none
    }
    
    func fill(with model: TextFieldCellViewModel) {
        
        labelName.text = model.name
        addressTextField.text = model.value
        infoCompletion = model.completion
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        infoCompletion?(text)
    }
    
}


