//
//  ProfileRegisterNewUserViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 09.09.2022.
//

import UIKit
import FirebaseAuth

class ProfileRegisterNewUserViewController: UIViewController, ProfileAlerts, ActivityIndicator {
    
    //MARK: VIEWS
    private let scrollVIew: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let emailTextField: EmailTextField = EmailTextField()
    
    private let passwordTextField: PasswordTextField = PasswordTextField(placeholder: "Password")
    
    private let repeatPasswordTextField: PasswordTextField = PasswordTextField(placeholder: "Repeat password")
    
    private let registerButton: ProfileButton = ProfileButton(configuration: .filled(), title: "Registration")
    
    //MARK: LIFECYCLE
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
            
            UIView.animate(withDuration: 0.2) {
                self?.registerButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            } completion: { isEnd in
                UIView.animate(withDuration: 0.35) {
                    self?.registerButton.transform = .identity
                }
            }
            
            guard let email = self?.emailTextField.text, !email.isEmpty, email.contains("@"),
                  let password = self?.passwordTextField.text, !password.isEmpty, password.count > 6,
                  let repeatPassword = self?.repeatPasswordTextField.text, password == repeatPassword  else {
                self?.showRegistrationValidation()
                return
            }
            
            self?.loadingIndicator()
            
            FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { [weak self] result, error in
                self?.removeLoadingIndicator()
                guard error == nil else {
                    print(FirebaseErrors.ErrorCreateUser)
                    return
                }
                self?.showCreateAccount(email: email, password: password)
                print("User created")
            }
            
        }), for: .touchUpInside)
    }
    
    
}

//MARK: CONSTRAINTS
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

//MARK: TEXTFIELD
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
