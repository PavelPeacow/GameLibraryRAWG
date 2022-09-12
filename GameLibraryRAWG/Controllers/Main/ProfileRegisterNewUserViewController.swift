//
//  ProfileRegisterNewUserViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 09.09.2022.
//

import UIKit
import FirebaseAuth

class ProfileRegisterNewUserViewController: UIViewController {
    
    private let scrollVIew: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let emailTextField: EmailTextField = EmailTextField()
    
    private let passwordTextField: PasswordTextField = PasswordTextField(placeholder: "Password")
    
    private let repeatPasswordTextField: PasswordTextField = PasswordTextField(placeholder: "Repeat password")
    
    private let registerButton: ProfileButton = ProfileButton(configuration: .filled(), title: "Registration")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollVIew)
        
        scrollVIew.addSubview(emailTextField)
        scrollVIew.addSubview(passwordTextField)
        scrollVIew.addSubview(repeatPasswordTextField)
        scrollVIew.addSubview(registerButton)
        
        createGestureRecognizer()
        
        addActiontoRegisterButton()
        
        setDelegates()
        setConstraints()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollVIew.frame = view.bounds	
    }
    
    private func setDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
    }
    
    private func createGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    private func addActiontoRegisterButton() {
        registerButton.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapRegisterButton()
        }), for: .touchUpInside)
    }
    
    private func didTapRegisterButton() {
        guard let email = emailTextField.text, !email.isEmpty, email.contains("@"),
              let password = passwordTextField.text, !password.isEmpty, password.count > 6,
              let repeatPassword = repeatPasswordTextField.text, password == repeatPassword  else {
            print("You need to be satisfied all")
            return
        }
        
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard error == nil else {
                print("Error when creating user")
                return
            }
            self?.showCreateAccount()
            print("User created")
        }
        
    }
    
    private func showCreateAccount() {
        let ac = UIAlertController(title: "Your account have been created", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }))
        present(ac, animated: true)
    }
    
}

extension ProfileRegisterNewUserViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            emailTextField.topAnchor.constraint(equalTo: scrollVIew.contentLayoutGuide.topAnchor, constant: 70),
            emailTextField.centerXAnchor.constraint(equalTo: scrollVIew.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            emailTextField.widthAnchor.constraint(equalTo: scrollVIew.widthAnchor, multiplier: 0.7),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            passwordTextField.centerXAnchor.constraint(equalTo: scrollVIew.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            passwordTextField.widthAnchor.constraint(equalTo: scrollVIew.widthAnchor, multiplier: 0.7),
            
            repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            repeatPasswordTextField.centerXAnchor.constraint(equalTo: scrollVIew.centerXAnchor),
            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: 40),
            repeatPasswordTextField.widthAnchor.constraint(equalTo: scrollVIew.widthAnchor, multiplier: 0.7),
            
            registerButton.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor, constant: 30),
            registerButton.centerXAnchor.constraint(equalTo: scrollVIew.centerXAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            registerButton.widthAnchor.constraint(equalTo: scrollVIew.widthAnchor, multiplier: 0.7),
            registerButton.bottomAnchor.constraint(equalTo: scrollVIew.bottomAnchor, constant: -200),
            
        ])
    }
}

extension ProfileRegisterNewUserViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
            
        case passwordTextField:
            repeatPasswordTextField.becomeFirstResponder()
            
        case repeatPasswordTextField:
            repeatPasswordTextField.resignFirstResponder()
            
        default: return false
        }
        return true
    }
    
}
