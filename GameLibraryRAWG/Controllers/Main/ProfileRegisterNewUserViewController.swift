//
//  ProfileRegisterNewUserViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 09.09.2022.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class ProfileRegisterNewUserViewController: UIViewController, ProfileAlerts, ActivityIndicator {
    
    //MARK: PROPERTIES
    private var imageData: Data?
    
    //dispatch
    private let dispatchGroup = DispatchGroup()
    private let dispatchqQueue = DispatchQueue(label: "registration")
    
    //MARK: VIEWS
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.image = UIImage(systemName: "photo")
        profileImage.isUserInteractionEnabled = true
        profileImage.contentMode = .scaleToFill
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 15
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        return profileImage
    }()
    
    private let setProfileImageIcon = ProfileSettingIconButton()
    
    private let userDisplayName: ProfileInputTextField = ProfileInputTextField(placeholder: "Nickname", isSecureTextEntryEnabled: false)
    
    private let emailTextField: ProfileInputTextField = ProfileInputTextField(placeholder: "Email", isSecureTextEntryEnabled: false)
    
    private let passwordTextField: ProfileInputTextField = ProfileInputTextField(placeholder: "Password", isSecureTextEntryEnabled: true)
    
    private let repeatPasswordTextField: ProfileInputTextField = ProfileInputTextField(placeholder: "Repeat password", isSecureTextEntryEnabled: true)
    
    private let registerButton: ProfileActionButton = ProfileActionButton(configuration: .filled(), title: "Registration")
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(profileImage)
        profileImage.addSubview(setProfileImageIcon)
        
        scrollView.addSubview(userDisplayName)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(repeatPasswordTextField)
        scrollView.addSubview(registerButton)
        
        createGestureRecognizer()
        
        setDefaultProfileImage()
        
        setProfileImageIcon.addTarget(self, action: #selector(changeProfileImageAction), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(addActiontoRegisterButton(_:)), for: .touchUpInside)
        
        setDelegates()
        setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
    }
    
    private func setDelegates() {
        userDisplayName.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
    }
    
    private func setDefaultProfileImage() {
        let data = profileImage.image?.jpegData(compressionQuality: 0.3)
        imageData = data
    }
    
    private func createGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc private func changeProfileImageAction() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc private func addActiontoRegisterButton(_ sender: UIButton) {
        
        //animation
        UIView.animate(withDuration: 0.2) {
            sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        } completion: { animationEnd in
            UIView.animate(withDuration: 0.35) {
                sender.transform = .identity
            }
        }
        
        //validation
        guard let displayName = userDisplayName.text, !displayName.isEmpty,
              let email = emailTextField.text, !email.isEmpty, email.contains("@"),
              let password = passwordTextField.text, !password.isEmpty, password.count > 6,
              let repeatPassword = repeatPasswordTextField.text, password == repeatPassword  else {
            showRegistrationValidationAlert()
            return
        }
        
        loadingIndicator()
        
        createNewUser(email: email, password: password, displayName: displayName)
                
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            self?.removeLoadingIndicator()
            self?.showCreateAccountAlert(email: email, password: password)
        })
        
    }
        
}

//MARK: Firebase user registration
extension ProfileRegisterNewUserViewController {
    
    private func createNewUser(email: String, password: String, displayName: String) {
        
        dispatchGroup.enter()
        
        FirebaseManager.shared.createUser(email: email, password: password) { [weak self] response in
            switch response {
                
            case .success(let result):
                print(result)
                
                FirebaseManager.shared.authUser(email: email, password: password) { response in
                    switch response {
                        
                    case .success(let result):
                        print(result)
                        
                        FirebaseManager.shared.createUserName(displayName: displayName) { response in
                            switch response {
                                
                            case .success(let result):
                                print(result)
                                
                                
                                FirebaseManager.shared.addImageToStorage(imageData: self?.imageData ?? Data()) { response in
                                    switch response {
                                    case .success(let result):
                                        print(result)
                                    case .failure(let error):
                                        print(error)
                                    }
                                    self?.dispatchGroup.leave()
                                }
                                
                                
                            case .failure(let error):
                                print(error)
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
    private func signInUser(email: String, password: String) {
        FirebaseManager.shared.authUser(email: email, password: password) { response in
            switch response {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func uploadUserName(userName: String) {
        FirebaseManager.shared.createUserName(displayName: userName) { response in
            switch response {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func uploadUserImage(imageData: Data) {
        FirebaseManager.shared.addImageToStorage(imageData: imageData) { response in
            switch response {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

//MARK: CONSTRAINTS
extension ProfileRegisterNewUserViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            setProfileImageIcon.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 5),
            setProfileImageIcon.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: -5),
            setProfileImageIcon.heightAnchor.constraint(equalToConstant: 30),
            setProfileImageIcon.widthAnchor.constraint(equalToConstant: 30),
            
            profileImage.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 70),
            profileImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 250),
            profileImage.heightAnchor.constraint(equalToConstant: 200),
            
            userDisplayName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 30),
            userDisplayName.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            userDisplayName.heightAnchor.constraint(equalToConstant: 40),
            userDisplayName.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7),
            
            emailTextField.topAnchor.constraint(equalTo: userDisplayName.bottomAnchor, constant: 30),
            emailTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            emailTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            passwordTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            passwordTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7),
            
            repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            repeatPasswordTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: 40),
            repeatPasswordTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7),
            
            registerButton.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor, constant: 30),
            registerButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            registerButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7),
            registerButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -200),
            
        ])
    }
}

extension ProfileRegisterNewUserViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            profileImage.image = image
            
            let data = image.jpegData(compressionQuality: 0.3)
            imageData = data
        } else {
            setDefaultProfileImage()
        }
        
        dismiss(animated: true)
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
