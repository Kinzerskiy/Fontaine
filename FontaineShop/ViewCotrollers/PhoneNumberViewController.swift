//
//  PhoneNumberViewController.swift
//  FontaineShop
//
//  Created by ANTON on 04.01.2023.
//

import UIKit
import FlagPhoneNumber
import FirebaseAuth

class PhoneNumberViewController: UIViewController {
    
    @IBOutlet weak var phoneTextField: FPNTextField!
    @IBOutlet weak var verifyButton: UIButton!
    
    var listController: FPNCountryListViewController!
    var phoneNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
        
    }
    
    func setupConfig() {
        
        verifyButton.isEnabled = false
        verifyButton.layer.cornerRadius = 12
        
        phoneTextField.displayMode = .list
        phoneTextField.delegate = self
        
        listController = FPNCountryListViewController(style: .grouped)
        listController?.setup(repository: phoneTextField.countryRepository)
        
        listController.didSelect = { country in
            self.phoneTextField.setFlag(countryCode: country.code)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CodeValidViewController,
        let verificationID = sender as? String {
            vc.verificationID = verificationID
        }
    }
    
    @IBAction func verifyPhone(_ sender: UIButton) {
        guard phoneNumber != nil else { return }
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { (verificationID, error) in
                
                if error != nil {
                    print(error?.localizedDescription ?? "is empty")
                } else {
                    guard let verificationID = verificationID else { return }
                    self.performSegue(withIdentifier: "validCode", sender: verificationID)
                }
            }
    }
    
    @IBAction func unwindToFirstScreen(_ segue: UIStoryboardSegue) {}
}

extension PhoneNumberViewController: FPNTextFieldDelegate {
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        //
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            verifyButton.isEnabled = true
            phoneNumber = textField.getFormattedPhoneNumber(format: .International)
        } else {
            verifyButton.isEnabled = false
        }
    }
    
    func fpnDisplayCountryList() {
        let navigationController = UINavigationController(rootViewController:  listController)
        listController.title = "Countries"
        phoneTextField.text = ""
        self.present(navigationController, animated: true)
    }
}

