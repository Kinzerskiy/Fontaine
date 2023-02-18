//
//  Order.swift
//  FontaineShop
//
//  Created by ANTON on 16.02.2023.
//

import Foundation


struct Order: Codable {

    var orderId: String
    var userId: String?
    var products: [BasketProduct]?
    var address: String?
    var comment: String?
    var deliveryTime: Date
    var isContactDelivey: Bool?
    var isNotCalling : Bool?
    var paymentCompleted: Bool?
}
