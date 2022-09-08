//
//  ProfileAuthorizationViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 08.09.2022.
//

import UIKit
import FirebaseAuth

class ProfileAuthorizationViewController: UIViewController {
    
    private let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.clearButtonMode = .whileEditing
        emailTextField.autocorrectionType = .no
        emailTextField.keyboardType = .emailAddress
        emailTextField.enablesReturnKeyAutomatically = true
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        return emailTextField
    }()
    
    private let passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        passwordTextField.enablesReturnKeyAutomatically = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        return passwordTextField
    }()
    
    private let signInButton: UIButton = {
        let signInButton = UIButton(configuration: UIButton.Configuration.filled())
        signInButton.setTitle("Sign In", for: .normal)
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        return signInButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        addActionToSignInButton()
        
        setConstraints()
        setDelegates()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func setDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func addActionToSignInButton() {
        signInButton.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapSignInButton()
        }), for: .touchUpInside)
    }
    
    private func didTapSignInButton() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else { return }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard error == nil else {
                self?.showCreateAccount(email: email, password: password)
                return
            }
            
            print("signed")
            self?.showSignInAlert()
        }
    }
    
    private func showCreateAccount(email: String, password: String) {
        let ac = UIAlertController(title: "Create account", message: "You need create an account", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { result, error in
                print("User created")
            }
        }))
        
        ac.addAction(UIAlertAction(title: "NO", style: .cancel))
        present(ac, animated: true)
    }
    
    private func showSignInAlert() {
        let ac = UIAlertController(title: "Nice", message: "You are sign in!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "hooray!", style: .default))
                     
        present(ac, animated: true)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
        ])
    }
    
}

extension ProfileAuthorizationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            emailTextField.becomeFirstResponder()
        }
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        true
    }
    
}
