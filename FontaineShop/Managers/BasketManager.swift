//
//  BasketManager.swift
//  FontaineShop
//
//  Created by ANTON on 11.01.2023.
//

import Foundation
import FirebaseDatabase

class BasketManager {
    
    static let shared = BasketManager()
    
    private var products: [BasketProduct] = []
    private init() {}
    
    
    func add(product: Product) {
        let index = products.firstIndex { basketProduct in
            basketProduct.product.uuid == product.uuid
        }
        if let  index = index {
            products[index].count += 1
        } else {
            products.append(.init(product: product, count: 1))
        }
    }
    
    func getNumberOfProducts() -> Int {
        return products.count
    }
    
    func getProduct(by index: Int) -> BasketProduct {
      
        products[index]
    }
    
    
    func plusProduct(by index: Int) {
        products[index].count += 1
    }
    
    
    func minusProduct(by index: Int) {
        
        products[index].count -= 1
        if products[index].count <= 0 {
            products.remove(at: index)
        }
    }
    
    func getPrice() -> Double {
        var total = 0.0
        for product in products {
            let tempTotal = product.product.price * Double(product.count)
            total = tempTotal + total
        }
        return total
    }
    
    func removeProduct(at index: Int) {
        products.remove(at: index)
    }
}
