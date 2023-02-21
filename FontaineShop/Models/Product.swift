//
//  Product.swift
//  FontaineShop
//
//  Created by ANTON on 11.01.2023.
//

import Foundation

struct Product: Codable {
    let uuid: String
    let imageName: String
    let name: String
    let price: Double
    
//    init(uuid: String, imageName: String, name: String, price: Double) {
//        self.uuid = uuid
//        self.imageName = imageName
//        self.name = name
//        self.price = price
//        }
//
//        convenience init(basketProduct: BasketProduct) {
//            self.init(uuid: basketProduct.product.uuid, imageName: basketProduct.product.imageName, name: basketProduct.product.name, price: basketProduct.product.price)
//        }
}
