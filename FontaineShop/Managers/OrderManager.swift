//
//  OrderManager.swift
//  FontaineShop
//
//  Created by ANTON on 16.02.2023.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

class OrderManager {
    
    let db = Firestore.firestore()
    let randomOrderId = String(Int.random(in: 1...1000000))
    var currentOrder = BasketManager.shared.order
    
    func saveOrder(order: Order, completion: @escaping () -> Void) {
        do {
            try db.collection("Orders").document(randomOrderId).setData(from: order)
            completion()
        } catch let error {
            print("Error writing user to Firestore: \(error)")
        }
    }
    
    
    func checkIfOrderExist(orderId: String, completion: @escaping (Bool) -> Void) {
        let docRef = db.collection("Orders").document(orderId)
        docRef.getDocument { (document, error) in
            if let document = document {
                completion(document.exists)
            } else {
                completion(false)
            }
        }
    }
}
