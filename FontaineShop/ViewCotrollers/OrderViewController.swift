//
//  OrderViewController.swift
//  FontaineShop
//
//  Created by ANTON on 20.02.2023.
//

import UIKit
import Foundation
import DateHelper
import FirebaseFirestoreSwift
import FirebaseFirestore

class OrderViewController: UIViewController {
    
    var order: Order?
    
    @IBOutlet weak var orderTableView: UITableView!
    var deliveryTimeTextField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderTableView.delegate = self
        orderTableView.dataSource = self
        
        orderTableView.register(.init(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        orderTableView.register(.init(nibName: "OrderProductsTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderProductsTableViewCell")
        
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker, textField: UITextField) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY, HH:mm"
        textField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func doneButtonTapped() {
        deliveryTimeTextField.resignFirstResponder()
    }
    
    func repeatOrder(_ order: Order) {
        let orderManager = OrderManager()
        var newOrder = Order(orderId: String(Int.random(in: 1...1000000)),
                             userId: order.userId,
                             products: order.products,
                             address: order.address,
                             comment: order.comment,
                             deliveryTime: order.deliveryTime,
                             orderCreated: Date(),
                             isContactDelivey: order.isContactDelivey,
                             isNotCalling: order.isNotCalling,
                             paymentCompleted: false,
                             total: order.total)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] (action) in
            if let textField = self?.deliveryTimeTextField, let newDeliveryTimeText = textField.text {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.YYYY, HH:mm"
                if let newDeliveryTime = dateFormatter.date(from: newDeliveryTimeText) {
                    newOrder.deliveryTime = newDeliveryTime
                }
                
                let alert = UIAlertController(title: "Thanks, the same order was created", message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "OK", style: .cancel) { cancel in
                        BasketManager.shared.order = OrderCreateModel()
                    self?.navigationController?.popToRootViewController(animated: true)
                }
                alert.addAction(cancel)
                self?.present(alert, animated: true, completion: nil)
                }
            }
        
        orderManager.saveOrder(order: newOrder) { [weak self] in
            let alert = UIAlertController(title: "New Delivery Time", message: "Enter new delivery time:", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                let deliveryTimeTextField = textField
                self?.deliveryTimeTextField = deliveryTimeTextField
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .dateAndTime
                datePicker.preferredDatePickerStyle = .wheels
                datePicker.addTarget(self, action: #selector(self?.datePickerValueChanged(_:textField:)), for: .valueChanged)
                textField.inputView = datePicker
                
                let toolbar = UIToolbar()
                toolbar.barStyle = .default
                toolbar.isTranslucent = true
                toolbar.tintColor = .systemBlue
                toolbar.sizeToFit()
                
                let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self?.doneButtonTapped))
                let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                toolbar.setItems([flexibleSpace, doneButton], animated: false)
                toolbar.isUserInteractionEnabled = true
                textField.inputAccessoryView = toolbar
                
                textField.placeholder = "Delivery Time"
                textField.keyboardType = .default
                textField.text = DateFormatter.localizedString(from: order.deliveryTime, dateStyle: .short, timeStyle: .short)
            }
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func repeatOrderAction(_ sender: Any) {
        guard let newOrder = order else { return }
        repeatOrder(newOrder)
    }
}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return order?.products?.count ?? 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
            cell.fill(with: order)
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderProductsTableViewCell", for: indexPath) as! OrderProductsTableViewCell
            
            if let products = order?.products {
                cell.fill(with: products[indexPath.row])
            }
            return cell
        }
    }
}
