//
//  SignUpViewController.swift
//  weldiwinfrontend
//
//  Created by sayari amin on 3/11/2025.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var Firstname: UITextField!
    @IBOutlet weak var Lastname: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Phonenumber: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ConfrimPassword: UITextField!
    
    
    // Optional role: default to parent
    private let role: UserRole = .parent
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - IBAction
    @IBAction func registerButtonTapped(_ sender: Any) {
        registerUser()
    }
    
    // MARK: - Registration Function
    private func registerUser() {
        // 1️⃣ Validate input
        guard
            let firstName = Firstname.text, !firstName.isEmpty,
            let lastName = Lastname.text, !lastName.isEmpty,
            let email = Email.text, !email.isEmpty,
            let phone = Phonenumber.text, !phone.isEmpty,
            let password = Password.text, !password.isEmpty,
            let confirmPassword = ConfrimPassword.text, !confirmPassword.isEmpty
        else {
            showAlert(title: "Error", message: "Please fill all fields")
            return
        }
        
        
        
        // 2️⃣ Build RegisterRequest object
        let registerData = RegisterRequest(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: phone,
            password: password,
            role: role,
            avatarUrl: nil
        )
        
        // 3️⃣ Call API via existing NetworkService
        NetworkService.shared.postRequest(to: .register, body: registerData) { result in
            print("Network completion called")
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        // Adjust this if your backend returns a different structure
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let message = json["message"] as? String {
                            self.showAlert(title: "Success", message: message)
                        } else {
                            self.showAlert(title: "Success", message: "Registered successfully")
                        }
                    }
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Helper: show alerts
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
