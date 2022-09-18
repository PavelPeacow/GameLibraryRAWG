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
    
    //MARK: VIEWS
    private let scrollVIew: UIScrollView = {
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
    
    private let setProfileImageIcon = ProfileGearSettingIconBtn()
    
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
        
        scrollVIew.addSubview(profileImage)
        profileImage.addSubview(setProfileImageIcon)
        
        scrollVIew.addSubview(userDisplayName)
        scrollVIew.addSubview(emailTextField)
        scrollVIew.addSubview(passwordTextField)
        scrollVIew.addSubview(repeatPasswordTextField)
        scrollVIew.addSubview(registerButton)
        
        createGestureRecognizer()
        
        setProfileImageIcon.addTarget(self, action: #selector(changeProfileImageAction), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(addActiontoRegisterButton(_:)), for: .touchUpInside)
        
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
        
        createNewUser(email: email, password: password)
        uploadUserImage(imageData: imageData ?? Data())
        uploadUserName(userName: displayName)

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.removeLoadingIndicator()
            self?.showCreateAccountAlert(email: email, password: password)
        }
        
    }
    
}

//MARK: Firebase user registration
extension ProfileRegisterNewUserViewController {
    
    func createNewUser(email: String, password: String) {
        
        dispatchGroup.enter()
        
        FirebaseManager.shared.createUser(email: email, password: password) { [weak self] response in
            switch response {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
                
            }
            
            self?.dispatchGroup.leave()
        }
        
    }
    
    func uploadUserName(userName: String) {
        
        dispatchGroup.enter()
        
        FirebaseManager.shared.createUserName(displayName: userName) { [weak self] response in
            switch response {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
            }
            
            self?.dispatchGroup.leave()
        }
    }
    
    func uploadUserImage(imageData: Data) {
        
        dispatchGroup.enter()
        
        FirebaseManager.shared.addImageToStorage(imageData: imageData) { [weak self] response in
            switch response {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
            }
            
            self?.dispatchGroup.leave()
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
            
            profileImage.topAnchor.constraint(equalTo: scrollVIew.contentLayoutGuide.topAnchor, constant: 70),
            profileImage.centerXAnchor.constraint(equalTo: scrollVIew.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 250),
            profileImage.heightAnchor.constraint(equalToConstant: 200),
            
            userDisplayName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 30),
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

extension ProfileRegisterNewUserViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            profileImage.image = image
            
            let data = image.jpegData(compressionQuality: 0.3)
            imageData = data
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
