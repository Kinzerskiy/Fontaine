//
//  DeliveryViewController.swift
//  FontaineShop
//
//  Created by ANTON on 31.01.2023.
//

import UIKit

struct OrderCreateModel {
    
   var orderId = String(Int.random(in: 1...1000000))
   var userId: String?
   var products: [BasketProduct] = []
   var address: String = ""
   var comment: String = ""
   var deliveryTime: Date = Date()
    var orderCreatedDate: Date = Date()
   var isContactDelivey: Bool = false
   var isNotCalling : Bool = false
   var totalPrice: Double { BasketManager.shared.getPrice() }
   var deliveryCoast: Double = 50.0
   var paymentMethod: PaymentMethod = .cash
    
   }

enum DeliveryRow {
    case product(BasketProduct)
    case textField(TextFieldCellViewModel)
    case switcher(SwitcherCellViewModel)
    case date(DateCellViewModel)
}

enum DeliverySection {
    case products([DeliveryRow])
    case textFields([DeliveryRow])
    case switchers([SwitcherCellViewModel])
    case date(DateCellViewModel)
    case orderTotal(OrederTotalViewModel)
    case paymentMethod(PaymentCellViewModel)
    case privacy(String)
}

class DateCellViewModel {
    var date: Date = Date()
    var dateCompletion: ((Date) -> Void)?
    
    init(date: Date, dateCompletion: @escaping (Date) -> Void) {
        self.date = date
        self.dateCompletion = dateCompletion
    }
}

class TextFieldCellViewModel {
    var name: String = ""
    var value: String = ""
    var completion: ((String) -> Void)
    
    init(name: String, value: String, completion: @escaping (String) -> Void) {
        self.name = name
        self.value = value
        self.completion = completion
    }
}

class SwitcherCellViewModel {
    var switcherName: String = ""
    var isOn: Bool = false
    var completion: ((Bool) -> Void)?
    
    init(switcherName: String, isOn: Bool, completion: @escaping (Bool) -> Void) {
        self.switcherName = switcherName
        self.isOn = isOn
        self.completion = completion
    }
}

class OrederTotalViewModel {
    var total: Double = 0.0
    var deliveryCoast = 0.0
    
    init(total: Double, deliveryCoast: Double = 0.0) {
        self.total = total
        self.deliveryCoast = deliveryCoast
    }
}

class PaymentCellViewModel {
    var value: PaymentMethod
    var completion: ((PaymentMethod) -> Void)?
    
    init(value: PaymentMethod, completion: @escaping ((PaymentMethod) -> Void)) {
        self.value = value
        self.completion = completion
    }
}

enum PaymentMethod: Int {
    case card, cash
}

class DeliveryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var payButton: UIButton!
    
    var productInBasket: [BasketProduct] = []
    var dataSource: [DeliverySection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTableView()
        updateDataSource()
    }
    
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(.init(nibName: "BasketTableViewCell", bundle: nil), forCellReuseIdentifier: "BasketTableViewCell")
        tableView.register(.init(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
        tableView.register(.init(nibName: "SwitcherTableViewCell", bundle: nil), forCellReuseIdentifier: "SwitcherTableViewCell")
        tableView.register(.init(nibName: "OrderTotalTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTotalTableViewCell")
        tableView.register(.init(nibName: "DateTableViewCell", bundle: nil), forCellReuseIdentifier: "DateTableViewCell")
        tableView.register(.init(nibName: "PaymentMethodTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentMethodTableViewCell")
    }
    
    func updateDataSource() {
        dataSource.removeAll()
        
        let productRows = BasketManager.shared.order.products.map { basketProduct in
            DeliveryRow.product(basketProduct)
        }
        
        dataSource.append(.products(productRows))
        
        let addressTextFieldViewModel = TextFieldCellViewModel.init(name: "Address", value: BasketManager.shared.order.address, completion: { [weak self] value in
            guard let self = self else { return }
            BasketManager.shared.order.address = value
            self.updateDataSource()
        })
        
        
        let dateTextFieldViewModel = DateCellViewModel.init(date: BasketManager.shared.order.deliveryTime, dateCompletion: { [weak self] date in
            guard let self = self else { return }
            BasketManager.shared.order.deliveryTime = date
            self.updateDataSource()
        })
        
        let commentTextFieldViewModel = TextFieldCellViewModel.init(name: "Comment", value: BasketManager.shared.order.comment) {  [weak self] value in
            guard let self = self else { return }
            BasketManager.shared.order.comment = value
            self.updateDataSource()
        }
        
        let addressTextFieldViewModelRow = DeliveryRow.textField(addressTextFieldViewModel)
        let commentTextFieldViewModelRow = DeliveryRow.textField(commentTextFieldViewModel)
        dataSource.append(.textFields([addressTextFieldViewModelRow, commentTextFieldViewModelRow]))
        
        let dontCallSwitcherViewModel = SwitcherCellViewModel(switcherName: "Do not call me", isOn:  BasketManager.shared.order.isNotCalling) { [weak self] isOn in
            guard let self = self else { return }
            BasketManager.shared.order.isNotCalling = isOn
            self.updateDataSource()
        }
        
        let withoutContactSwitcherVideModel = SwitcherCellViewModel(switcherName: "Without contact", isOn:  BasketManager.shared.order.isContactDelivey) { [weak self] isOn in
            guard let self = self else { return }
            BasketManager.shared.order.isContactDelivey = isOn
            self.updateDataSource()
        }
        
        dataSource.append(.switchers([dontCallSwitcherViewModel, withoutContactSwitcherVideModel]))
        
        let orderTotal = OrederTotalViewModel(total: BasketManager.shared.order.totalPrice, deliveryCoast: BasketManager.shared.order.deliveryCoast)
        dataSource.append(.orderTotal(orderTotal))
        
        
        let paymentMethodCellViewModel = PaymentCellViewModel(value: BasketManager.shared.order.paymentMethod, completion: { [weak self] paymentMethod in
            guard let self = self else { return }
            BasketManager.shared.order.paymentMethod = paymentMethod
            self.updateDataSource()
        })
        dataSource.append(.paymentMethod(paymentMethodCellViewModel))
        
        
        tableView.reloadData()
        
    }
    
    @IBAction func payButton(_ sender: Any) {
        let order = Order(orderId: BasketManager.shared.order.orderId, userId: BasketManager.shared.order.userId, products: BasketManager.shared.order.products, address: BasketManager.shared.order.address, comment: BasketManager.shared.order.comment, deliveryTime: BasketManager.shared.order.deliveryTime, orderCreated: Date(), isContactDelivey: BasketManager.shared.order.isContactDelivey, isNotCalling: BasketManager.shared.order.isNotCalling, paymentCompleted: false, total: BasketManager.shared.getPrice())
        
        if  BasketManager.shared.order.paymentMethod == .cash {
            
            let orderManager = OrderManager()
            
            
            orderManager.saveOrder(order: order) { [weak self] in
                let alert = UIAlertController(title: "Thanks, your order was created", message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "OK", style: .cancel) { cancel in
                    BasketManager.shared.order = OrderCreateModel()
                    
                    self?.navigationController?.popToRootViewController(animated: true)
                }
                alert.addAction(cancel)
                self?.present(alert, animated: true)
            }
        } else {
            // push fondy screen with payment fillling card, after the payment open the home screen
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FondyViewController") as! FondyViewController
            vc.order = order
            self.navigationController?.pushViewController(vc, animated: true)
            }
    }
        // after order will be created we should remove the current order from baskerManager
        
        //        BasketManager.shared.order = OrderCreateModel()  - this os the code for clear order
        
    }

extension DeliveryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch dataSource[section] {
        case .products(let products): return products.count
        case .switchers(let switchers): return switchers.count
        case .textFields(let textFields): return textFields.count
        default: return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dataSource[indexPath.section] {
        case .products(let products):
            let productRow = products[indexPath.row]
            switch productRow {
            case .product(let product):
                let cell = tableView.dequeueReusableCell(withIdentifier: "BasketTableViewCell", for: indexPath) as! BasketTableViewCell
                cell.fill(with: product)
                cell.selectionStyle = .none
                
                cell.addCompletion = { [weak self] in
                    BasketManager.shared.plusProduct(by: indexPath.row)
                    self?.updateDataSource()
                }
                
                cell.removeCompletion = { [weak self] in
                    BasketManager.shared.minusProduct(by: indexPath.row)
                    self?.updateDataSource()
                }
                return cell
                
            default: return UITableViewCell()
            }
            
        case .textFields(let textFields):
            let textFieldRow = textFields[indexPath.row]
            switch textFieldRow {
            case .textField(let textField):
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
                cell.fill(with: textField)
                
                return cell
                
            default: return UITableViewCell()
            }
            
        case .switchers(let switchers):
            
            let switcherRow = switchers[indexPath.row]
            switch switcherRow {
            case (let switcherViewModel):
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitcherTableViewCell", for: indexPath) as! SwitcherTableViewCell
                cell.fill(with: switcherViewModel)
                
                return cell
                
            }
            
        case .orderTotal(let orderTotal):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTotalTableViewCell", for: indexPath) as! OrderTotalTableViewCell
            cell.fill(with: orderTotal)
            return cell
            
        case .date(let date):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateTableViewCell", for: indexPath) as! DateTableViewCell
            cell.fill(with: date)
            return cell
            
            
        case .paymentMethod(let paymentMethod):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTableViewCell", for: indexPath) as! PaymentMethodTableViewCell
            cell.fill(with: paymentMethod)
            return cell
            
        case .privacy(let privacyText): return UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource[indexPath.section] {
        case .products: return 150
        case .switchers: return 50
        case .textFields: return 70
        case .date: return 70
        case .orderTotal: return 120
        case .paymentMethod: return 70
        case .privacy: return 50
        }
    }
}
