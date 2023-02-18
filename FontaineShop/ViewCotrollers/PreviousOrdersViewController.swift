//
//  PreviousOrdersViewController.swift
//  FontaineShop
//
//  Created by ANTON on 17.02.2023.
//

import UIKit
import FirebaseAuth

class PreviousOrdersViewController: UIViewController {
    
    @IBOutlet weak var ordersTableView: UITableView!
    
    let orderManager = OrderManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTableView()
        
    }
    
    func getData() {
        orderManager.getOrders {
            self.ordersTableView.reloadData()
        }
    }
    
    func prepareTableView() {
        if let tableView = ordersTableView {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(.init(nibName: "PreviousOrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "PreviousOrdersTableViewCell")
        }
    }
}

extension PreviousOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderManager.getNumberOfOrders()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousOrdersTableViewCell", for: indexPath) as! PreviousOrdersTableViewCell
        let order = OrderManager.orders[indexPath.row]
        cell.fill(with: order)
        return cell
    }
    }
