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
        self.navigationItem.setHidesBackButton(true, animated: true)
        
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
    
    func showCodeValidVC(verificationID: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dvc = storyboard.instantiateViewController(withIdentifier: "CodeValidViewController") as! CodeValidViewController
        dvc.verificationID = verificationID
        self.present(dvc, animated: true)
    }
    
    @IBAction func verifyPhone(_ sender: UIButton) {
        guard phoneNumber != nil else { return }
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { (verificationID, error) in
                
                if error != nil {
                    print(error?.localizedDescription ?? "is empty")
                } else {
                    self.showCodeValidVC(verificationID: verificationID ?? "is empty") 
                }
            }
    }
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

