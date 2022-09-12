//
//  ProfileAuthorizationViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 08.09.2022.
//

import UIKit
import FirebaseAuth

class ProfileAuthorizationViewController: UIViewController {
    
    private let scrollVIew: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let emailTextField: EmailTextField = EmailTextField()
    
    private let passwordTextField: PasswordTextField = PasswordTextField(placeholder: "Password")
    
    private let signInButton: ProfileButton = ProfileButton(configuration: .filled(), title: "Sign in")
    
    private let dontHaveAccountButton: ProfileButton = ProfileButton(configuration: .bordered(), title: "Don't have an account?")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollVIew)
        
        scrollVIew.addSubview(emailTextField)
        scrollVIew.addSubview(passwordTextField)
        scrollVIew.addSubview(signInButton)
        scrollVIew.addSubview(dontHaveAccountButton)
        
        configureNavBar()
        
        createGestureRecognizer()
        
        addActionToSignInButton()
        addActionToDontHaveAccountButton()
        
        setConstraints()
        setDelegates()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollVIew.frame = view.bounds
    }
    
    private func setDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func createGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    private func configureNavBar() {
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
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
    
}

extension ProfileAuthorizationViewController {
    
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
            
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            signInButton.centerXAnchor.constraint(equalTo: scrollVIew.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.widthAnchor.constraint(equalTo: scrollVIew.widthAnchor, multiplier: 0.7),
            
            dontHaveAccountButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 15),
            dontHaveAccountButton.centerXAnchor.constraint(equalTo: scrollVIew.centerXAnchor),
            dontHaveAccountButton.heightAnchor.constraint(equalToConstant: 50),
            dontHaveAccountButton.widthAnchor.constraint(equalTo: scrollVIew.widthAnchor, multiplier: 0.7),
            dontHaveAccountButton.bottomAnchor.constraint(equalTo: scrollVIew.contentLayoutGuide.bottomAnchor, constant: -150),
        ])
    }
}

extension ProfileAuthorizationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
}
