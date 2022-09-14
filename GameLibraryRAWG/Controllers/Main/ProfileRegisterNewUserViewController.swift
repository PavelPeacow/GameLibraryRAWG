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
    
    private let userDisplayName: EmailTextField = EmailTextField(placeholder: "Nickname")
    
    private let emailTextField: EmailTextField = EmailTextField(placeholder: "Email")
    
    private let passwordTextField: PasswordTextField = PasswordTextField(placeholder: "Password")
    
    private let repeatPasswordTextField: PasswordTextField = PasswordTextField(placeholder: "Repeat password")
    
    private let registerButton: ProfileButton = ProfileButton(configuration: .filled(), title: "Registration")
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollVIew)
        
        scrollVIew.addSubview(userDisplayName)
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
        userDisplayName.delegate = self
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
            
            guard let displayName = self?.userDisplayName.text, !displayName.isEmpty,
                  let email = self?.emailTextField.text, !email.isEmpty, email.contains("@"),
                  let password = self?.passwordTextField.text, !password.isEmpty, password.count > 6,
                  let repeatPassword = self?.repeatPasswordTextField.text, password == repeatPassword  else {
                self?.showRegistrationValidationAlert()
                return
            }
            
            self?.loadingIndicator()
            
            FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { [weak self] result, error in
                self?.removeLoadingIndicator()
                guard error == nil else {
                    print(FirebaseErrors.ErrorCreateUser)
                    return
                }
                
                guard let uid = result?.user.uid else { print(FirebaseErrors.UserNotFound); return }
                
                self?.showCreateAccountAlert(email: email, password: password)
                print("User created")
                
                FirebaseManager.shared.firestore.collection("Users").document(uid).setData(["user_name": displayName]) { error in
                    guard error == nil else {
                        print(FirebaseErrors.ErrorCreateDocument)
                        return
                    }
                   
                    print("UserDisplayName created")
                }
            }
            
            
            
        }), for: .touchUpInside)
    }
    
    
}

//MARK: CONSTRAINTS
extension ProfileRegisterNewUserViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            userDisplayName.topAnchor.constraint(equalTo: scrollVIew.contentLayoutGuide.topAnchor, constant: 70),
            userDisplayName.centerXAnchor.constraint(equalTo: scrollVIew.centerXAnchor),
            userDisplayName.heightAnchor.constraint(equalToConstant: 40),
            userDisplayName.widthAnchor.constraint(equalTo: scrollVIew.widthAnchor, multiplier: 0.7),
            
            emailTextField.topAnchor.constraint(equalTo: userDisplayName.bottomAnchor, constant: 30),
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
        case userDisplayName:
            emailTextField.becomeFirstResponder()
            
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
