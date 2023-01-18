//
//  BasketViewController.swift
//  FontaineShop
//
//  Created by ANTON on 11.01.2023.
//

import UIKit

class BasketViewController: UIViewController {

    @IBOutlet weak var basketTableView: UITableView!
    @IBOutlet weak var placeOrderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preparetableView()
        updateButton()
    }
    
    func preparetableView() {
        basketTableView.delegate = self
        basketTableView.dataSource = self
        
        basketTableView.register(.init(nibName: "BasketTableViewCell", bundle: nil), forCellReuseIdentifier: "BasketTableViewCell")
    }
    
    func updateButton() {
        let title = "Order for " + "\(BasketManager.shared.getPrice())"
        placeOrderButton.setTitle(title, for: .normal)
    }
    
}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        BasketManager.shared.getNumberOfProducts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketTableViewCell", for: indexPath) as! BasketTableViewCell
        
        let product = BasketManager.shared.getProduct(by: indexPath.row)
        
        cell.fill(with: product)
        
        cell.addCompletion = {
            BasketManager.shared.plusProduct(by: indexPath.row)
            tableView.reloadData()
            self.updateButton()
        }
        
        cell.removeCompletion = {
            BasketManager.shared.minusProduct(by: indexPath.row)
            tableView.reloadData()
            self.updateButton()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteProduct = UIContextualAction(style: .destructive, title: "Delete") { [weak self] ( contextualAction,
            view, boolValue) in
            
            BasketManager.shared.removeProduct(at: indexPath.row)
            tableView.reloadData()
            self?.updateButton()
        }
        deleteProduct.backgroundColor = .red
        deleteProduct.image = UIImage(systemName: "trash.fill")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteProduct])
        return swipeActions
        }
    }
