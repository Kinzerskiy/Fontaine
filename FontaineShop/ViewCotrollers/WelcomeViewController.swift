//
//  WelcomeViewController.swift
//  FontaineShop
//
//  Created by ANTON on 06.01.2023.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = ""
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        var charIndex = 0.0
        let titleText = "FONTAINE"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] (timer) in
        
        let userManager = UserManager()
            
        guard let currentUser = Auth.auth().currentUser else {
            self?.performSegue(withIdentifier: "welcomeSegue", sender: self)
            return
        }
        
        userManager.checkIfUserExist(userId: currentUser.uid) { isExist in
            if isExist {
                self?.performSegue(withIdentifier: "fromWelcomeToProduct", sender: self)
            } else {
                self?.performSegue(withIdentifier: "welcomeSegue", sender: self)
            }
        }
    }
}
}
