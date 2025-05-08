//
//  AuthViewController.swift
//  Explore Minsk
//
//  Created by Кирилл Сысоев on 06.05.2025.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

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
    
    override func viewDidLoad() { //исполняется при создании экрана
        super.viewDidLoad()

        incorrectEmailLabel.isHidden = true
        incorrectPasswordLabel.isHidden = true
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        authButton.addTarget(self, action: #selector(authButtonTapped), for: .touchUpInside)
        changeAuth.addTarget(self, action: #selector(changeAuthTapped), for: .touchUpInside)
    }
    
    @objc func authButtonTapped() { // кнопка регистрации иои входа нажата
        if isValidEmail() && isValidPassword() {
            
            incorrectEmailLabel.isHidden = true
            incorrectPasswordLabel.isHidden = true
            
            guard let email = emailTextField.text, let password = passwordTextField.text else {
                return
            }
            
            if signUp {
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        print("Error creating user: \(error)")
                        return
                    } else if let result = result {
                        db.child("users").child(Auth.auth().currentUser!.uid).setValue([
                            "email": email,
                            "password": password,
                            "name": "Name"
                        ])
                    }
                }
            } else {
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if let error = error {
                        print("Error sign in: \(error)")
                        self.showAlert(title: "Ошибка!", message: "Неправильно введены данные или такого аккаунта не существует. Хотите зарегистрироваться?")
                        return
                    }
                }
            }
        } else {
            if !isValidEmail() {
                incorrectEmailLabel.isHidden = false
            } else {
                incorrectEmailLabel.isHidden = true
            }
            
            if !isValidPassword() {
                incorrectPasswordLabel.isHidden = false
            } else {
                incorrectPasswordLabel.isHidden = true
            }
        }
    }
    
    @objc func changeAuthTapped() { // поменял на регистрацию
        signUp.toggle()
    }
    

    func isValidEmail() -> Bool { // проверка на корректность эл почты
        if let email = emailTextField.text, !email.isEmpty {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            return email.range(of: emailRegex, options: .regularExpression, range: nil, locale: nil) != nil
        } else {
            return false
        }
    }
    
    func isValidPassword() -> Bool { // проверка на корректность пароля
        guard let password = passwordTextField.text, !password.isEmpty else {
            return false
        }
        guard password.count >= 6 else {
            return false
        }
            
        return true
    }
    
    func showAlert(title: String, message: String) { // показывает ошибку
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }

}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // скрывает клавиатуру
        textField.resignFirstResponder()
        return true
    }
}
