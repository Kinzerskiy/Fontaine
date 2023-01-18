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
}
