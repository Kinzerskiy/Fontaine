//
//  UserProfileViewController.swift
//  FontaineShop
//
//  Created by ANTON on 16.01.2023.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import Kingfisher

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var userPhoto: UIImageView!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        let userManager = UserManager()
        let userID = Auth.auth().currentUser!.uid
        
        userManager.getUserInfo(userId: userID) { [weak self] user in
            self?.user = user
            self?.updateUI()
        }
    }
    
    
    func updateUI() {
        saveButton.layer.cornerRadius = 12
        guard let imageUrl = user?.imageUrl, let source = URL.init(string: imageUrl) else { return }
        
        userPhoto.kf.setImage(with: source)
    }
    
    @IBAction func didTapButton(_ sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        let userName = nameTextField.text
        let address = addressTextField.text
        
        
        if let currentUser = Auth.auth().currentUser {
            let phoneNumber = currentUser.phoneNumber
            let user = User(uuid: currentUser.uid, phoneNumber: phoneNumber, fullName: userName, address: address, imageUrl: user?.imageUrl)
            let userManager = UserManager()
            userManager.saveUserFields(user: user) {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                let navigationController = UINavigationController(rootViewController: viewController)
                
                UIApplication.shared.windows.first?.rootViewController = navigationController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        }
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        guard let imageData = image.pngData(), let currentUser = Auth.auth().currentUser else { return }
        
        let fileManager = FileManager()
        
        fileManager.uploadPhoto(userId: currentUser.uid, imageData: imageData) { [weak self] urlString in
            guard let self = self, let user = self.user else { return }
            let newUser = User(uuid: currentUser.uid, phoneNumber: user.phoneNumber, fullName: user.fullName, address: user.address, imageUrl: urlString)
            
            let userManager = UserManager()
            userManager.saveUserFields(user: newUser) { [weak self] in
                self?.user = newUser
                self?.updateUI()
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
