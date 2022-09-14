//
//  ProfileSettingsViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 13.09.2022.
//

import UIKit

class ProfileSettingsViewController: UIViewController {
    
    private let profileImageBtn: UIImageView = {
        let profileImage = UIImageView()
        profileImage.image = UIImage(named: "cat")
        profileImage.isUserInteractionEnabled = true
        profileImage.contentMode = .scaleToFill
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 15
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        return profileImage
    }()
    
    private let changeImageIcon = ProfileGearSettingIconBtn()
    
    private let changeDisplayNameIcon = ProfileGearSettingIconBtn()

    private let displayName: UILabel = {
        let displayName = UILabel()
        displayName.translatesAutoresizingMaskIntoConstraints = false
        displayName.textAlignment = .center
        displayName.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        displayName.text = "Some nickname t Some nickname t"
        displayName.sizeToFit()
        return displayName
    }()
    
    private let imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }()
    
    private let signOutButton = ProfileButton(configuration: .gray(), title: "Sign Out")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(profileImageBtn)
        profileImageBtn.addSubview(changeImageIcon)
        
        view.addSubview(displayName)
        displayName.addSubview(changeDisplayNameIcon)
        
        view.addSubview(signOutButton)
        
        
        changeImageIcon.addTarget(self, action: #selector(addActionToPorifileImageBtn), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(addActionToSignOutButton), for: .touchUpInside)
        
        
        setDelegates()
        setConstraints()
    }
    
    private func setDelegates() {
        imagePicker.delegate = self
    }
    
    @objc private func addActionToSignOutButton() {
        try? FirebaseManager.shared.auth.signOut()
        navigationController?.setViewControllers([ProfileAuthorizationViewController()], animated: true)
    }
    
    @objc private func addActionToPorifileImageBtn() {
        present(imagePicker, animated: true)
    }
    
}

extension ProfileSettingsViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            changeImageIcon.topAnchor.constraint(equalTo: profileImageBtn.topAnchor, constant: 5),
            changeImageIcon.trailingAnchor.constraint(equalTo: profileImageBtn.trailingAnchor, constant: -5),
            changeImageIcon.heightAnchor.constraint(equalToConstant: 30),
            changeImageIcon.widthAnchor.constraint(equalToConstant: 30),
            
            profileImageBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            profileImageBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageBtn.widthAnchor.constraint(equalToConstant: 250),
            profileImageBtn.heightAnchor.constraint(equalToConstant: 200),
            
            changeDisplayNameIcon.topAnchor.constraint(equalTo: displayName.topAnchor),
            changeDisplayNameIcon.trailingAnchor.constraint(equalTo: displayName.trailingAnchor, constant: 25),
            
            displayName.topAnchor.constraint(equalTo: profileImageBtn.bottomAnchor, constant: 15),
            displayName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            displayName.heightAnchor.constraint(equalToConstant: 40),
            
            signOutButton.topAnchor.constraint(equalTo: displayName.bottomAnchor, constant: 25),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
            signOutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
        ])
    }
}

extension ProfileSettingsViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageBtn.image = image
        }
        
        dismiss(animated: true)
    }
    
    
}
