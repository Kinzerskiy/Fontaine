//
//  FondyViewController.swift
//  FontaineShop
//
//  Created by ANTON on 16.02.2023.
//

import UIKit
import Cloudipsp

class FondyViewController: UIViewController, PSPayCallbackDelegate {
    
    @IBOutlet weak var merchantIDTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var cardInputLayout: PSCardInputLayout!
    var cloudipspWebView: PSCloudipspWKWebView!
    
    private var orderManager: OrderManager!
    var order: Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        orderManager = OrderManager()
    }
    
    func prepareUI() {
        
        
        cloudipspWebView = PSCloudipspWKWebView(frame: CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.addSubview(cloudipspWebView)
    }
    
    
    
    private func payOrder() {
        
        guard let card = self.cardInputLayout.confirm() else {
            debugPrint("Empty card")
            let alert = UIAlertController(title: "Please add card", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(cancel)
            self.present(alert, animated: true)
            return
        }
        
        let cloudipspApi = PSCloudipspApi(merchant: Int(merchantIDTextField.text!) ?? 0, andCloudipspView: cloudipspWebView)
        let generatedOrderId = String(order.orderId)
        let amount = (order.total ?? 0) * 100
        let paymentOrder = PSOrder(order: Int(amount), aStringCurrency: "UAH", aIdentifier: generatedOrderId, aAbout: descriptionTextField.text!)
        cloudipspApi?.pay(card, with: paymentOrder, andDelegate: self)
    }
    
    
        
    func saveOrder() {
        let orderManager = OrderManager()
        
        
        
        orderManager.saveOrder(order: order) { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                
            }
        }
    }
        
        @IBAction func onPayPressed(_ sender: Any) {
                    
                
                guard let merchantIDString = merchantIDTextField.text,
                        let merchantID = Int(merchantIDString), merchantID > 0 else {
                    debugPrint("Invalid merchant ID")
                    return
                }
                
                guard let description = descriptionTextField.text,
                        !description.isEmpty else {
                    debugPrint("Description is required")
                    return
                }
            payOrder()
           
            
        }
            //        let generatedOrderId = String(format: "Swift_%d", arc4random())
            //        let cloudipspApi = PSCloudipspApi(merchant: Int(textFieldMerchantID.text!) ?? 0, andCloudipspView: self.cloudipspWebView)
            //        let card = self.cardInputLayout.confirm()
            //        if (card == nil) {
            //            debugPrint("Empty card")
            //            let alert = UIAlertController(title: "Please add card", message: nil, preferredStyle: .alert)
            //            let cancel = UIAlertAction(title: "OK", style: .cancel)
            //            alert.addAction(cancel)
            //            self.present(alert, animated: true)
            //        } else {
            //            let paymentOrder = PSOrder(order: Int(textFieldAmount.text!) ?? 0, aStringCurrency: textFieldCurrency.text!, aIdentifier: generatedOrderId, aAbout: textFieldDescription.text!)
            //            cloudipspApi?.pay(card, with: paymentOrder, andDelegate: self)
            //
            //            let orderManager = OrderManager()
            //
            //            let order = Order(orderId: BasketManager.shared.order.orderId, userId: BasketManager.shared.order.userId, products: BasketManager.shared.order.products, address: BasketManager.shared.order.address, comment: BasketManager.shared.order.comment, deliveryTime: BasketManager.shared.order.deliveryTime, isContactDelivey: BasketManager.shared.order.isContactDelivey, isNotCalling: BasketManager.shared.order.isNotCalling, paymentCompleted: true)
            //
            //            orderManager.saveOrder(order: order) { [weak self] in
            //                self?.activityIndicator.isHidden = false
            //                self?.activityIndicator.startAnimating()
            //
            //
            //                let alert = UIAlertController(title: "Thanks, your order was created", message: nil, preferredStyle: .alert)
            //                let cancel = UIAlertAction(title: "OK", style: .default) { cancel in
            //                    BasketManager.shared.order = OrderCreateModel()
            //                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //                    let vc = storyboard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
            //                    self?.present(vc, animated: true, completion: nil)
            //                }
            //                alert.addAction(cancel)
            //                self?.present(alert, animated: true)
            //            }
            //        }

    @IBAction func onTestCardPressed(_ sender: Any) {
        self.cardInputLayout.test()
    }

    func onPaidProcess(_ receipt: PSReceipt!) {
        debugPrint("onPaidProcess: %@", receipt.status)
        if receipt.status.rawValue == 4 {
            saveOrder()
        }
    }
    
    func onPaidFailure(_ error: Error!) {
        debugPrint("onPaidFailure: %@", error.localizedDescription)
    }
    
    func onWaitConfirm() {
        debugPrint("onWaitConfirm")
    }
}

