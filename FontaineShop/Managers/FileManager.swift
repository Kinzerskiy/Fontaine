//
//  FileManager.swift
//  FontaineShop
//
//  Created by ANTON on 17.01.2023.
//

import Foundation
import FirebaseStorage

class FileManager {
    
    func uploadPhoto(userId: String, imageData: Data, completion: @escaping (String) -> Void) {
        
        let storage = Storage.storage().reference()
        let path = "\(userId)/userAvatar.png"
        
        storage.child(path).putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            
            storage.child(path).downloadURL { url, error in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                print("Download url: \(urlString)")
                
                DispatchQueue.main.async {
                    completion(urlString)
                }
            }
        }
    }
}
