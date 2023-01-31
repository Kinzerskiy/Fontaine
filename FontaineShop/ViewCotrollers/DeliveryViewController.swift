//
//  DeliveryViewController.swift
//  FontaineShop
//
//  Created by ANTON on 31.01.2023.
//

import UIKit

class DeliveryViewController: UIViewController {
    
    var productInBasket: [BasketProduct]?
    
    @IBOutlet weak var orderCostLabel: UILabel!
    @IBOutlet weak var deliveryCostLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var paymentMethodCollectionView: UICollectionView!
    
    @IBOutlet weak var deliveryAddressTextField: UITextField!
    @IBOutlet weak var deliveryDateTextField: UITextField!
    @IBOutlet weak var userCommentTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareColletionView()
    }
    
    
    
    func prepareColletionView() {
        paymentMethodCollectionView.delegate = self
        paymentMethodCollectionView.dataSource = self
        
        paymentMethodCollectionView.register(.init(nibName: "PaymentCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "PaymentCollectionViewCell")
    }

    @IBAction func callBackSwitch(_ sender: Any) {
        
    }
    
    @IBAction func contactlessDeliverySwitch(_ sender: Any) {
        
    }
    
    @IBAction func privacyPolicyButton(_ sender: Any) {
        
    }
    
    @IBAction func payButton(_ sender: Any) {
        
    }
}

extension DeliveryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentCollectionViewCell", for: indexPath) as! PaymentCollectionViewCell
        
        return cell
    }
}

extension DeliveryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketTableViewCell", for: indexPath) as! BasketTableViewCell
        
        return cell
    }
    
    
    
}
