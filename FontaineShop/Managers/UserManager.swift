//
//  UserManager.swift
//  FontaineShop
//
//  Created by ANTON on 06.01.2023.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore


class UserManager {
    
    let db = Firestore.firestore()
    
    func checkIfUserExist(userId: String, completion: @escaping (Bool) -> Void) {
        let docRef = db.collection("Users").document(userId)
        docRef.getDocument { (document, error) in
            if let document = document {
                completion(document.exists)
            } else {
                completion(false)
            }
        }
    }
    
    func saveUserFields(user: User, completion: @escaping () -> Void) {
        do {
            try db.collection("Users").document(user.uuid).setData(from: user)
            completion()
        } catch let error {
            print("Error writing user to Firestore: \(error)")
        }
    }
    
    func getUserInfo(userId: String, completion: @escaping (User?) -> Void) {
        let docRef = db.collection("Users").document(userId)
        docRef.getDocument(as: User.self) { result in
            switch result {
                case .success(let user):
                completion(user)
                       case .failure(let error):
                    print("Error decoding user: \(error)")
                }
        }
    }
}
