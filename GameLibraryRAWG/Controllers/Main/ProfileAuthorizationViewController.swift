//
//  ProfileAuthorizationViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 08.09.2022.
//

import UIKit
import FirebaseAuth

class ProfileAuthorizationViewController: UIViewController, ActivityIndicator, ProfileAlerts {
    
    //MARK: VIEWS
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let emailTextField: ProfileInputTextField = ProfileInputTextField(placeholder: "Email", isSecureTextEntryEnabled: false)
    
    private let passwordTextField: ProfileInputTextField = ProfileInputTextField(placeholder: "Password", isSecureTextEntryEnabled: true)
    
    private let signInButton: ProfileActionButton = ProfileActionButton(configuration: .filled(), title: "Sign in")
    
    private let dontHaveAccountButton: ProfileActionButton = ProfileActionButton(configuration: .bordered(), title: "Don't have an account?")
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(signInButton)
        scrollView.addSubview(dontHaveAccountButton)
        
        configureNavBar()
        
        createGestureRecognizer()
        
        dontHaveAccountButton.addTarget(self, action: #selector(showRegistrationSheet), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(trySignInUser(_:)), for: .touchUpInside)
        
        setConstraints()
        setDelegates()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
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
    
    @objc private func trySignInUser(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        } completion: { animationEnd in
            UIView.animate(withDuration: 0.35) {
                sender.transform = .identity
            }
        }
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showEmptyFieldsAlert()
            return
        }
        
        Task { [weak self] in
            self?.loadingIndicator()
            await self?.authUser(email: email, password: password)
            self?.removeLoadingIndicator()
        }
        
    }
    
    @objc private func showRegistrationSheet() {
        let vc = ProfileRegisterNewUserViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: Firebase async authentification
extension ProfileAuthorizationViewController {
    
    private func authUser(email: String, password: String) async {
        do {
            let result = try await FirebaseManager.shared.authUser(email: email, password: password)
            showSignInAlert()
            print(result)
        } catch let error {
            showInvalidUserAlert()
            print(error)
        }
    }
    
}

//MARK: CONSTRAINTS
extension ProfileAuthorizationViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            emailTextField.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 70),
            emailTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            emailTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            passwordTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            passwordTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7),
            
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            signInButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7),
            
            dontHaveAccountButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 15),
            dontHaveAccountButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            dontHaveAccountButton.heightAnchor.constraint(equalToConstant: 50),
            dontHaveAccountButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7),
            dontHaveAccountButton.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -150),
        ])
    }
}

//MARK: TEXTFIELD
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
