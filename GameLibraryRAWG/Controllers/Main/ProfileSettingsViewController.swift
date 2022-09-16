//
//  ProfileSettingsViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 13.09.2022.
//

import UIKit
import FirebaseStorage
import SDWebImage

class ProfileSettingsViewController: UIViewController, ProfileAlerts {
    
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
    
    private let changeImageIcon = ProfileGearSettingIconBtn()
    
    private let changeDisplayNameIcon = ProfileGearSettingIconBtn()

    private let displayName: UILabel = {
        let displayName = UILabel()
        displayName.translatesAutoresizingMaskIntoConstraints = false
        displayName.textAlignment = .center
        displayName.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        displayName.sizeToFit()
        return displayName
    }()
    
    private let signOutButton = ProfileButton(configuration: .gray(), title: "Sign Out")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(profileImage)
        profileImage.addSubview(changeImageIcon)
        
        view.addSubview(changeDisplayNameIcon)
        changeDisplayNameIcon.addSubview(displayName)
        
        view.addSubview(signOutButton)
        
        
        changeImageIcon.addTarget(self, action: #selector(changeProfileImageAction), for: .touchUpInside)
        changeDisplayNameIcon.addTarget(self, action: #selector(changeUserDisplayNameAction), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(addActionToSignOutButton), for: .touchUpInside)
        
        
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUserNameDisplay()
        
        if let uid = FirebaseManager.shared.auth.currentUser?.uid {
            FirebaseManager.shared.storage.reference().child("Users Images/\(uid)/userAvatar.jpg").downloadURL { [weak self] url, error in
                
                guard error == nil else { print("error url"); return }
                
                self?.profileImage.sd_imageIndicator = SDWebImageActivityIndicator.large
                self?.profileImage.sd_setImage(with: url)
            }
        }
        
        
    }
    
    private func fetchUserNameDisplay() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { print(); return }
        
        FirebaseManager.shared.firestore.collection("Users").document(uid).getDocument { [weak self] snapshot, error in
            guard error == nil else { print(FirebaseErrors.ErrorGetUserDocuments); return }
            
            if let snapshot = snapshot {
                let data = snapshot.get("user_name") as? String ?? "Unknown"
                DispatchQueue.main.async {
                    self?.displayName.text = data
                }
            }
            
        }
    }
    
    @objc private func changeProfileImageAction() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc private func changeUserDisplayNameAction() {
        showChangeUserDisplayNameAlert()
    }
    
    @objc private func addActionToSignOutButton() {
        try? FirebaseManager.shared.auth.signOut()
        navigationController?.setViewControllers([ProfileAuthorizationViewController()], animated: true)
    }
    
    private func showChangeUserDisplayNameAlert() {
        let ac = UIAlertController(title: "Change nickname",
                                   message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.addAction(UIAlertAction(title: "Change", style: .default, handler: { [weak self] _ in
            guard let nick = ac.textFields?.first?.text else { return }
            
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { print(FirebaseErrors.UserNotFound); return }
            
            FirebaseManager.shared.firestore.collection("Users").document(uid).setData(["user_name": nick]) { error in
                guard error == nil else { print(FirebaseErrors.ErrorCreateDocument); return }
            }
            
            print("DisplayName changed to \(nick)")
            DispatchQueue.main.async {
                self?.displayName.text = nick
            }
        }))
        
        
        present(ac, animated: true)
        
    }
    
}

extension ProfileSettingsViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            changeImageIcon.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 5),
            changeImageIcon.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: -5),
            changeImageIcon.heightAnchor.constraint(equalToConstant: 30),
            changeImageIcon.widthAnchor.constraint(equalToConstant: 30),
            
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 250),
            profileImage.heightAnchor.constraint(equalToConstant: 200),
            
            changeDisplayNameIcon.topAnchor.constraint(equalTo: displayName.topAnchor),
            changeDisplayNameIcon.trailingAnchor.constraint(equalTo: displayName.trailingAnchor, constant: 25),
            changeDisplayNameIcon.heightAnchor.constraint(equalToConstant: 20),
            changeDisplayNameIcon.widthAnchor.constraint(equalToConstant: 20),
            
            displayName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 15),
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
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { print(FirebaseErrors.UserNotFound); return }
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.image = image
            
            let data = image.jpegData(compressionQuality: 0.3)
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            if let data = data {
                FirebaseManager.shared.storage.reference().child("Users Images/\(uid)/userAvatar.jpg").putData(data, metadata: metadata) { metadata, error in
                    guard error == nil else { print(FirebaseErrors.ErrorPutImageToStorage); return }
                    
                    print("UserAvatar succesfully uploaded")
                }
            }
            
            
        }
        
        dismiss(animated: true)
    }
    
    
}
