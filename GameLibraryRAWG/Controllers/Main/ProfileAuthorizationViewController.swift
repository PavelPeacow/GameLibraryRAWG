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
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.alignment = .fill
        return stackView
    }()
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        addViewToStackView()
        
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
    
    private func addViewToStackView() {
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(dontHaveAccountButton)
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
            if error.localizedDescription == "The password is invalid or the user does not have a password." {
                showIncorrectPasswordSignInAlert()
            } else if error.localizedDescription == "Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later." {
                showAccountDisableSignInAlert()
            }
            else {
                showInvalidUserAlert()
                print(error)
            }
        }
    }
    
}

//MARK: CONSTRAINTS
extension ProfileAuthorizationViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 70),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -150),
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
