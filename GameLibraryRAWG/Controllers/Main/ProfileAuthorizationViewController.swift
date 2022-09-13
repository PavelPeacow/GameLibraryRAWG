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
    private let scrollVIew: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let emailTextField: EmailTextField = EmailTextField()
    
    private let passwordTextField: PasswordTextField = PasswordTextField(placeholder: "Password")
    
    private let signInButton: ProfileButton = ProfileButton(configuration: .filled(), title: "Sign in")
    
    private let dontHaveAccountButton: ProfileButton = ProfileButton(configuration: .bordered(), title: "Don't have an account?")
    
    //MARK: LIFECYCLE
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
    
    //MARK: SignIn auth
    private func addActionToSignInButton() {
        signInButton.addAction(UIAction(handler: { [weak self] _ in
            
            UIView.animate(withDuration: 0.2) {
                self?.signInButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            } completion: { isEnd in
                UIView.animate(withDuration: 0.35) {
                    self?.signInButton.transform = .identity
                }
            }
            
            guard let email = self?.emailTextField.text, !email.isEmpty,
                  let password = self?.passwordTextField.text, !password.isEmpty else {
                self?.showEmptyFields()
                return }
            
            self?.loadingIndicator()
            
            FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { [weak self] result, error in
                self?.removeLoadingIndicator()
                guard error == nil else {
                    print(FirebaseErrors.UserNotFound)
                    self?.showInvalidUser()
                    return
                }
                
                print("signed!!!")
                self?.showSignInAlert()
            }
            
        }), for: .touchUpInside)
    }
    
    //MARK: show registration sheet
    private func addActionToDontHaveAccountButton() {
        dontHaveAccountButton.addAction(UIAction(handler: { [weak self] _ in
            
            let vc = ProfileRegisterNewUserViewController()
            
            self?.present(vc, animated: true)
            
        }), for: .touchUpInside)
    }
    
}

//MARK: CONSTRAINTS
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
