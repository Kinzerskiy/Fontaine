//
//  CodeValidViewController.swift
//  FontaineShop
//
//  Created by ANTON on 04.01.2023.
//

import UIKit
import FirebaseAuth

class CodeValidViewController: UIViewController {
    
    @IBOutlet weak var codeTextView: UITextView!
    @IBOutlet weak var checkCodeButton: UIButton!
    
    var verificationID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func updateUI() {
        checkCodeButton.isEnabled = false
        checkCodeButton.layer.cornerRadius = 12
        
        codeTextView.layer.borderWidth = 1
        codeTextView.layer.cornerRadius = 12
        codeTextView.delegate = self
    }
    
    
    
    @IBAction func checkCodeAction(_ sender: UIButton) {
        guard let code = codeTextView.text else { return }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: code)
        
        Auth.auth().signIn(with: credential) { [weak self] _, error in
            if error != nil {
                let alert = UIAlertController(title: error?.localizedDescription, message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Okey", style: .cancel)
                alert.addAction(cancel)
                self?.present(alert, animated: true)
                
            } else {
                let userManager = UserManager()
                guard let currentUser = Auth.auth().currentUser else { return }
                
                userManager.checkIfUserExist(userId: currentUser.uid) { isExist in
                    if isExist {
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                        let navigationController = UINavigationController(rootViewController: viewController)
                        
                        UIApplication.shared.windows.first?.rootViewController = navigationController
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                    } else {
                        let user = User(uuid: currentUser.uid, phoneNumber: nil, fullName: nil, address: nil, imageUrl: nil)
                        userManager.saveUserFields(user: user) { [weak self] in
                            self?.performSegue(withIdentifier: "fromCodeToProfileFields", sender: nil)
                        }
                    }
                }
                
            }
        }
    }
}
            
extension CodeValidViewController: UITextViewDelegate {
                
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentCharacterCount = textView.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        
        let newLength = currentCharacterCount + text.count - range.length
        return newLength <= 6
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text?.count == 6 {
            checkCodeButton.isEnabled = true
        } else {
            checkCodeButton.isEnabled = false
        }
    }
}
