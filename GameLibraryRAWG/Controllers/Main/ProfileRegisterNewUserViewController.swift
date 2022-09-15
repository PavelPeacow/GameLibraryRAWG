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
    
    //MARK: VIEWS
    private let scrollVIew: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.image = UIImage(named: "cat")
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
        
        addActiontoRegisterButton()
        
        setProfileImageIcon.addTarget(self, action: #selector(changeProfileImageAction), for: .touchUpInside)
        
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
    
    private func addActiontoRegisterButton() {
        registerButton.addAction(UIAction(handler: { [weak self] _ in
            
            //animation
            UIView.animate(withDuration: 0.2) {
                self?.registerButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            } completion: { isEnd in
                UIView.animate(withDuration: 0.35) {
                    self?.registerButton.transform = .identity
                }
            }
            
            //validation
            guard let displayName = self?.userDisplayName.text, !displayName.isEmpty,
                  let email = self?.emailTextField.text, !email.isEmpty, email.contains("@"),
                  let password = self?.passwordTextField.text, !password.isEmpty, password.count > 6,
                  let repeatPassword = self?.repeatPasswordTextField.text, password == repeatPassword  else {
                self?.showRegistrationValidationAlert()
                return
            }
            
            self?.loadingIndicator()
            
            //createUser
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
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                
                if let imageData = self?.imageData {
                    FirebaseManager.shared.storage.reference().child("Users Images/\(uid)/userAvatar.jpg").putData(imageData, metadata: metadata) { metadata, error in
                        guard error == nil else { print(FirebaseErrors.ErrorPutImageToStorage); return }
                        
                        print("UserAvatar succesfully uploaded")
                    }
                }
                
            }
        }), for: .touchUpInside)
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
