//
//  User.swift
//  FontaineShop
//
//  Created by ANTON on 06.01.2023.
//

import Foundation

struct User: Codable {
    let uuid: String
    let phoneNumber: String?
    let fullName: String?
    let address: String?
    let imageUrl: String?
}
