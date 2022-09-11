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
    
    private let dontHaveAccountButton: UIButton = {
        let dontHaveAccountButton = UIButton(configuration: UIButton.Configuration.bordered())
        dontHaveAccountButton.setTitle("Don't have an account?", for: .normal)
        dontHaveAccountButton.translatesAutoresizingMaskIntoConstraints = false
        return dontHaveAccountButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(dontHaveAccountButton)
        
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        addActionToSignInButton()
        addActionToDontHaveAccountButton()
        
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
    
    private func addActionToDontHaveAccountButton() {
        dontHaveAccountButton.addAction(UIAction(handler: { [weak self] _ in
            let vc = ProfileRegisterNewUserViewController()
            self?.present(vc, animated: true)
        }), for: .touchUpInside)
    }
    
    private func didTapSignInButton() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else { return }
        
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard error == nil else {
                print("No such user found!")
                return
            }
            
            print("signed!!!")
            self?.showSignInAlert()
        }
    }
    
    private func showSignInAlert() {
        let ac = UIAlertController(title: "Nice", message: "You are sign in!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "hooray!", style: .default, handler: { [weak self] _ in
            let vc = ProfileMainViewController()
            self?.navigationController?.setViewControllers([vc], animated: true)
        }))
                     
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
            
            dontHaveAccountButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 15),
            dontHaveAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dontHaveAccountButton.heightAnchor.constraint(equalToConstant: 50),
            dontHaveAccountButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
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
