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
    
    var order: OrderCreateModel = OrderCreateModel()
    
    private init() {}
    
    
    func add(product: Product) {
        let index = order.products.firstIndex { basketProduct in
            basketProduct.product.uuid == product.uuid
        }
        if let  index = index {
            order.products[index].count += 1
        } else {
            order.products.append(.init(product: product, count: 1))
        }
    }
    
    func getNumberOfProducts() -> Int {
        return order.products.count
    }
    
    func getProduct(by index: Int) -> BasketProduct {
      
        order.products[index]
    }
    
    
    func plusProduct(by index: Int) {
        order.products[index].count += 1
    }
    
    
    func minusProduct(by index: Int) {
        
        order.products[index].count -= 1
        if order.products[index].count <= 0 {
            order.products.remove(at: index)
        }
    }
    
    func getPrice() -> Double {
        var total = 0.0
        for product in order.products {
            let tempTotal = product.product.price * Double(product.count)
            total = tempTotal + total
        }
        return total
    }
    
    func removeProduct(at index: Int) {
        order.products.remove(at: index)
    }
}
