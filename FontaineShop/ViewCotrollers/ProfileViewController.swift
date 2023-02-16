//
//  ProfileViewController.swift
//  FontaineShop
//
//  Created by ANTON on 20.01.2023.
//

import UIKit
import FirebaseAuth
import Kingfisher

class ProfileViewController: UIViewController {

    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    let userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserData()
    }
    
    func prepareUI() {
        
        userPhoto.layer.cornerRadius = userPhoto.frame.height / 2
    }
    
    func updateUI(with user: User) {
        userNameLabel.text = user.fullName
        addressLabel.text = user.address
       
        guard let imageUrl = user.imageUrl, let source = URL.init(string: imageUrl) else { return }
        userPhoto.kf.setImage(with: source)
    }
    
    func loadUserData() {
        guard let currentUser = Auth.auth().currentUser else { return }
        userManager.getUserInfo(userId: currentUser.uid) { [weak self] user in
            guard let user = user else { return }
            self?.updateUI(with: user)
        }
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
