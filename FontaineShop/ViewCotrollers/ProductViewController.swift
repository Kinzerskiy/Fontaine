//
//  ProductViewController.swift
//  
//
//  Created by ANTON on 11.01.2023.
//

import UIKit

class ProductViewController: UIViewController {

    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var basketButton: UIButton!
    
    let productManager = ProductManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        prepareCollectionView()
        getData()
    }
    
    func updateUI() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        basketButton.layer.cornerRadius = 12
    }
    
    func getData() {
        productManager.getProducts { [weak self] in
            self?.productCollectionView.reloadData()
        }
    }
    
    func prepareCollectionView() {
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        productCollectionView.register(.init(nibName: "ProductCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        
    }
    
    @IBAction func basketAction(_ sender: Any) {
        performSegue(withIdentifier: "fromProductToBusket", sender: nil)
    }
    
}

extension ProductViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productManager.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        
        let product = productManager.models[indexPath.row]
        cell.fill(with: product)
        
        cell.buyComplition = {
            BasketManager.shared.add(product: product)
            
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        .init(width: 100, height: 100 )
//    }
    
}
