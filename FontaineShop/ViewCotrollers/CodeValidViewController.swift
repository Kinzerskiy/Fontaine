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
        setupConfig()
    }
    
    func setupConfig() {
        checkCodeButton.isEnabled = false
        checkCodeButton.layer.cornerRadius = 12
        codeTextView.delegate = self
    }
    
    func showContentVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dvc = storyboard.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        self.present(dvc, animated: true)
    }
    
    @IBAction func checkCodeAction(_ sender: UIButton) {
        guard let code = codeTextView.text else { return }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: code)
        
        Auth.auth().signIn(with: credential) { _, error in
            if error != nil {
                let alert = UIAlertController(title: error?.localizedDescription, message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Okey", style: .cancel)
                alert.addAction(cancel)
                self.present(alert, animated: true)
                
            } else {
                self.showContentVC()
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
