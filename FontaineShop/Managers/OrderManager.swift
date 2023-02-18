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
    
//    static let shared = OrderManager()
    static var orders: [Order] = []
    
    
//    let db = Firestore.firestore()
    
    
//    func saveOrder(order: Order, completion: @escaping () -> Void) {
//        
//        let db = Firestore.firestore()
//        
//        do {
//            try db.collection("Orders").document(order.orderId).setData(from: order)
//            completion()
//        } catch let error {
//            print("Error writing order to Firestore: \(error)")
//        }
//    }
    
    func saveOrder(order: Order, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        guard let data = try? Firestore.Encoder().encode(order) else {
            print("Error encoding order")
            return
        }
        db.collection("Orders").document(order.orderId).setData(data) { error in
            if let error = error {
                print("Error writing order to Firestore: \(error)")
            } else {
                completion()
            }
        }
    }

    
    func getOrder(by index: Int) -> Order {
        OrderManager.orders[index]
    }
    
    func getNumberOfOrders() -> Int {
        return OrderManager.orders.count
    }
    
//    func getOrders(completion: @escaping () -> Void) {
//
//        let db = Firestore.firestore()
//        let docRef = db.collection("Orders")
//
//        docRef.getDocuments { [weak self] data, error in
//            if let error = error {
//                print(error)
//            }
//
//            guard let data = data else { return }
//
//            for document in data.documents {
//                let orderData = document.data()
//
//                    let orderId = document.documentID
//                    let products = orderData["products"] as? [BasketProduct]
//                    let address = orderData["address"] as? String
//                    let deliveryTime = orderData["deliveryTime"] as! Date
//                    let order = Order.init(orderId: orderId, userId: nil, products: products, address: address, comment: nil, deliveryTime: deliveryTime, isContactDelivey: nil, isNotCalling: nil, paymentCompleted: nil)
//                    self?.orders.append(order)
//                }
//            }
//        }
    
    func getOrders(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("Orders")
        
        docRef.getDocuments { data, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print("No data found")
                return
            }
            
            var orders = [Order]()
            
            for document in data.documents {
                let orderData = document.data()
                let orderId = document.documentID
                let userId = orderData["userId"] as? String
                let products = orderData["products"] as? [BasketProduct]
                let address = orderData["address"] as? String
                let comment = orderData["comment"] as? String
                let deliveryTime = orderData["deliveryTime"] as? Date ?? Date()
                let isContactDelivery = orderData["isContactDelivery"] as? Bool
                let isNotCalling = orderData["isNotCalling"] as? Bool
                let paymentCompleted = orderData["paymentCompleted"] as? Bool
                
                let order = Order(orderId: orderId,
                                  userId: userId,
                                  products: products,
                                  address: address,
                                  comment: comment,
                                  deliveryTime: deliveryTime,
                                  isContactDelivey: isContactDelivery,
                                  isNotCalling: isNotCalling,
                                  paymentCompleted: paymentCompleted)
                
                orders.append(order)
            }
            
            OrderManager.orders = orders
            completion()
        }
    }

    }
