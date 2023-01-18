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

class UserProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var userPhoto: UIImageView!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        prepareUI()
        loadData()
    }
    
//    func prepareUI() {
////        userPhoto.contentMode = .scaleAspectFit
////        phoneNumberLabel.isHidden = true
////        nameLabelInfo.isHidden = true
//    }
    
    func loadData() {
        let userManager = UserManager()
        let userID = Auth.auth().currentUser!.uid
        
        userManager.getUserInfo(userId: userID) { [weak self] user in
            self?.user = user
            self?.updateUI()
        }
    }
    
    func updateUI() {
        self.navigationItem.setHidesBackButton(true, animated: true)
//        self.phoneNumberLabel.text = user?.phoneNumber
//        self.nameLabelInfo.text = user?.fullName
//        self.adressLabelInfo.text = user?.address
        
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
            let user = User(uuid: currentUser.uid, phoneNumber: phoneNumber, fullName: userName, address: address, imageUrl: nil)
            let userManager = UserManager()
            userManager.saveUserFields(user: user) {
                self.performSegue(withIdentifier: "fromEditToProduct", sender: nil)
            }
        }
    }
}

extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        guard let imageData = image.pngData(), let currentUser = Auth.auth().currentUser else { return }
        
        let fileManager = FileManager()
        
        fileManager.uploadPhoto(userId: currentUser.uid, imageData: imageData) { [weak self] urlString in
            guard let self = self, let user = self.user else { return }
            let newUser = User(uuid: currentUser.uid, phoneNumber: user.phoneNumber, fullName: user.fullName, address: user.address, imageUrl: urlString)
            
            let userManager = UserManager()
            userManager.saveUserFields(user: user) { [weak self] in
                self?.user = newUser
                self?.updateUI()
            }
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
