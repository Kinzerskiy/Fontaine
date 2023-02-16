//
//  DateTableViewCell.swift
//  FontaineShop
//
//  Created by ANTON on 08.02.2023.
//

import UIKit

class DateTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var dateTextField: UITextField!
    
    var dateCompletion: ((Date) -> Void)?
    
    let datePicker = UIDatePicker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateTextField.inputView = datePicker
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
        
//        let localeId = Locale.preferredLanguages.first
//        datePicker.locale = Locale(identifier: localeId!)
        
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        
        dateTextField.delegate = self
        dateTextField.inputAccessoryView = toolBar
    }

    @objc func doneAction() {
        setupDateField(by: datePicker.date)
        dateCompletion?(datePicker.date)
    }
    
    func setupDateField(by date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY, HH:mm"
        dateTextField.text = dateFormatter.string(from: date)
    }
    
    func fill(with model: DateCellViewModel) {
        setupDateField(by: model.date)
        dateCompletion = model.dateCompletion
    }
}
