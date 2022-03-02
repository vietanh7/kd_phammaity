//
//  LoginViewController.swift
//  ReliaTest
//
//  Created by Ty Pham on 02/03/2022.
//

import UIKit

class LoginViewController: BaseViewController, AuthDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    var viewModel: AuthViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = AuthViewModel(delegate: self)
    }
    

    @IBAction func loginTapped(_ sender: Any) {
        
        guard let email = emailTextField.text, let password = passwordTextfield.text else {
            self.showErrorAlert(error: "Please enter email and password")
            return
        }
        
        viewModel?.login(email: email, password: password)
    }
  
    
    func requestSuccess() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func requestError(error: String) {
        self.showErrorAlert(error: error)
    }
}
