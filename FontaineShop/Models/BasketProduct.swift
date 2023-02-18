//
//  BasketProduct.swift
//  FontaineShop
//
//  Created by ANTON on 11.01.2023.
//

import Foundation


class BasketProduct: Codable {
    var product: Product
    var count: Int
    
    init(product: Product, count: Int) {
        self.product = product
        self.count = count
    }
}
