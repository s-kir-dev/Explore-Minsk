//
//  AuthViewController.swift
//  Explore Minsk
//
//  Created by Кирилл Сысоев on 06.05.2025.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var incorrectEmailLabel: UILabel!
    @IBOutlet weak var incorrectPasswordLabel: UILabel!
    
    @IBOutlet weak var authButton: UIButton!
    
    @IBOutlet weak var changeAuth: UIButton!
    @IBOutlet weak var withoutAccountLabel: UILabel!
    
    var signUp: Bool = false {
        willSet {
            if newValue { //если переключил на регистрацию
                authButton.setTitle("Sign up", for: .normal)
                withoutAccountLabel.isHidden = true
                changeAuth.isHidden = true
                incorrectEmailLabel.isHidden = true
                incorrectPasswordLabel.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        incorrectEmailLabel.isHidden = true
        incorrectPasswordLabel.isHidden = true
    }
    
    @objc func authButtonTapped() { // кнопка регистрации иои входа нажата
        if isValidEmail() && isValidPassword() {
            guard let email = emailTextField.text, let password = passwordTextField.text else {
                return
            }
            
            if signUp {
                
            } else {
                
            }
            
        } else if !isValidEmail() {
            incorrectEmailLabel.isHidden = false
        } else if !isValidPassword() {
            incorrectPasswordLabel.isHidden = false
        }
    }
    

    func isValidEmail() -> Bool { // проверка на корректность эл почты
        if let email = emailTextField.text, email.isEmpty {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            return email.range(of: emailRegex, options: .regularExpression, range: nil, locale: nil) != nil
        } else {
            return false
        }
    }
    
    func isValidPassword() -> Bool { // проверка на корректность пароля
        guard let password = passwordTextField.text, password.isEmpty else {
            return false
        }
        guard password.count >= 6 else {
            return false
        }
            
        return true
    }

}
