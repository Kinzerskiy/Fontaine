//
//  OrderManager.swift
//  FontaineShop
//
//  Created by ANTON on 16.02.2023.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

class OrderManager {
    
    static var orders: [Order] = []
    
    
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
    
    func getOrders(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
//        guard let currentUser = Auth.auth().currentUser  else { return }
        let docRef = db.collection("Orders")
//            .whereField("userId", isEqualTo: currentUser.uid)

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
                let productsData = orderData["products"] as? [[String: Any]]
                let address = orderData["address"] as? String
                let comment = orderData["comment"] as? String
                let deliveryTime = orderData["deliveryTime"] as? Date ?? Date()
                let isContactDelivery = orderData["isContactDelivery"] as? Bool
                let isNotCalling = orderData["isNotCalling"] as? Bool
                let paymentCompleted = orderData["paymentCompleted"] as? Bool
                let total = orderData["total"] as? Double
                let orderCreated = orderData["orderCreated"] as? Date ?? Date()

                var products = [BasketProduct]()
                if let productsData = productsData {
                    for productData in productsData {
                        do {
                            let product = try Firestore.Decoder().decode(Product.self, from: productData["product"] as Any)
                            let count = productData["count"] as? Int ?? 0
                            products.append(BasketProduct(product: product, count: count))
                        } catch {
                            print("Error decoding product: \(error)")
                        }
                    }
                }

                let order = Order(orderId: orderId,
                                  userId: userId,
                                  products: products,
                                  address: address,
                                  comment: comment,
                                  deliveryTime: deliveryTime,
                                  orderCreated: orderCreated,
                                  isContactDelivey: isContactDelivery,
                                  isNotCalling: isNotCalling,
                                  paymentCompleted: paymentCompleted,
                                  total: total)

                orders.append(order)
            }

            OrderManager.orders = orders
            completion()
        }
    }
}
