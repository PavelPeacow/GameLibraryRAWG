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
    private var isEmailAlreadyUse: Bool!
        
    //MARK: VIEWS
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.image = UIImage(named: "userNoImage")
        profileImage.isUserInteractionEnabled = true
        profileImage.contentMode = .scaleAspectFill
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
        
        scrollView.addSubview(profileImage)
        profileImage.addSubview(setProfileImageIcon)
        
        scrollView.addSubview(stackView)
        addViewToStackView()
        
        createGestureRecognizer()
        
        setDefaultProfileImage()
        
        setProfileImageIcon.addTarget(self, action: #selector(changeProfileImageAction), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerNewUserAction(_:)), for: .touchUpInside)
        
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
    
    private func addViewToStackView() {
        stackView.addArrangedSubview(userDisplayName)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(repeatPasswordTextField)
        stackView.addArrangedSubview(registerButton)
    }
    
    private func setDefaultProfileImage() {
        let data = profileImage.image?.jpegData(compressionQuality: 0.8)
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
    
    @objc private func registerNewUserAction(_ sender: UIButton) {
        
        //animation
        UIView.animate(withDuration: 0.2) {
            sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        } completion: { animationEnd in
            UIView.animate(withDuration: 0.35) {
                sender.transform = .identity
            }
        }
        
        //validation
        guard let displayName = userDisplayName.text, validateUsername(with: userDisplayName.text ?? "") else {
            showNicknameInvalidValidationAlert()
            return
        }
        
        guard let email = emailTextField.text, validateEmail(with: emailTextField.text ?? "") else {
            showEmailInvalidValidationAlert()
            return
        }
        guard  let password = passwordTextField.text, validatePassword(with: passwordTextField.text ?? "") else {
            showPasswordInvalidValidationAlert()
            return
        }
        guard let repeatPassword = repeatPasswordTextField.text, password == repeatPassword  else {
            showPasswordAreNotTheSameValidationAlert()
            return
        }
        
        Task { [weak self] in
            self?.loadingIndicator()
            navigationItem.setHidesBackButton(true, animated: true)
            
            await self?.isEmailAlreadyInUser(email: email)
            
            if !isEmailAlreadyUse {
                
                await self?.createNewUser(email: email, password: password)
                await self?.signInUser(email: email, password: password)
                await self?.uploadUserName(userName: displayName)
                await self?.uploadUserImage(imageData: imageData ?? Data())
                
                //if there are no error when create account, show profileView, if error - show alert
                if let _ = FirebaseManager.shared.auth.currentUser {
                    self?.showCreateAccountAlert(email: email, password: password)
                } else {
                    self?.showInvalidCreateAccountAlert()
                }
            } else {
                self?.showEmailInUseAlert()
            }
                
            self?.removeLoadingIndicator()
            navigationItem.setHidesBackButton(false, animated: true)

        }
        
    }
    
}

//MARK: Firebase async user registration
extension ProfileRegisterNewUserViewController {
    
    private func isEmailAlreadyInUser(email: String) async {
        do {
            let result = try await FirebaseManager.shared.isEmailAlreadyInUse(email: email)
            print(result)
            isEmailAlreadyUse = result
        } catch let error {
            print(error)
        }
    }
    
    private func createNewUser(email: String, password: String) async {
        do {
            let result = try await FirebaseManager.shared.createUser(email: email, password: password)
            print(result)
        } catch let error {
            print(error)
        }
    }
    
    private func signInUser(email: String, password: String) async {
        do {
            let result = try await FirebaseManager.shared.authUser(email: email, password: password)
            print(result)
        } catch let error {
            print(error)
        }
    }
    
    private func uploadUserName(userName: String) async {
        do {
            let result = try await FirebaseManager.shared.createUserName(displayName: userName)
            print(result)
        } catch let error {
            print(error)
        }
    }
    
    private func uploadUserImage(imageData: Data) async {
        do {
            let result = try await FirebaseManager.shared.addImageToStorage(imageData: imageData)
            print(result)
        } catch let error {
            print(error)
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
            
            profileImage.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 15),
            profileImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 250),
            profileImage.heightAnchor.constraint(equalToConstant: 200),
            
            stackView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -50),
        ])
    }
}

extension ProfileRegisterNewUserViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            profileImage.image = image
            
            let data = image.jpegData(compressionQuality: 0.8)
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
