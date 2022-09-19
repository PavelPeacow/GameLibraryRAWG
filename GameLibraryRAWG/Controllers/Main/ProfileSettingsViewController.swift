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
    
    public let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.isUserInteractionEnabled = true
        profileImage.contentMode = .scaleToFill
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 15
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        return profileImage
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let changeImageIconButton = ProfileSettingIconButton()
    
    private let changeDisplayNameIconButton = ProfileSettingIconButton()

    public let displayName: UILabel = {
        let displayName = UILabel()
        displayName.translatesAutoresizingMaskIntoConstraints = false
        displayName.textAlignment = .center
        displayName.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        displayName.sizeToFit()
        return displayName
    }()
    
    private let signOutButton = ProfileActionButton(configuration: .gray(), title: "Sign Out")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(profileImage)
        profileImage.addSubview(changeImageIconButton)
        
        scrollView.addSubview(changeDisplayNameIconButton)
        changeDisplayNameIconButton.addSubview(displayName)
        
        scrollView.addSubview(signOutButton)
        
        changeImageIconButton.addTarget(self, action: #selector(changeProfileImageAction), for: .touchUpInside)
        changeDisplayNameIconButton.addTarget(self, action: #selector(changeUserDisplayNameAction), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(signOutAction), for: .touchUpInside)
        
        setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
    }
        
    @objc private func changeProfileImageAction() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc private func changeUserDisplayNameAction() {
        showChangeUserDisplayNameAlert { displayName in
            Task { [weak self] in
                self?.loadingIndicator()
                await self?.uploadChangedName(displayName: displayName)
                self?.removeLoadingIndicator()
            }
        }
    }
    
    @objc private func signOutAction() {
        try? FirebaseManager.shared.auth.signOut()
        navigationController?.setViewControllers([ProfileAuthorizationViewController()], animated: true)
    }
    
}

//MARK: Firebase async calls
extension ProfileSettingsViewController {
    
    private func uploadChangedImage(imageData: Data) async {
        do {
            let result = try await FirebaseManager.shared.addImageToStorage(imageData: imageData)
            print(result)
        } catch let error {
            print(error)
        }
    }
    
    private func uploadChangedName(displayName: String) async {
        do {
            let result = try await FirebaseManager.shared.createUserName(displayName: displayName)
            DispatchQueue.main.async { [weak self] in
                self?.displayName.text = displayName
            }
            print(result)
        } catch let error {
            print(error)
        }
    }
    
}

extension ProfileSettingsViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            changeImageIconButton.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 5),
            changeImageIconButton.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: -5),
            changeImageIconButton.heightAnchor.constraint(equalToConstant: 30),
            changeImageIconButton.widthAnchor.constraint(equalToConstant: 30),
            
            profileImage.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 15),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 250),
            profileImage.heightAnchor.constraint(equalToConstant: 200),
            
            changeDisplayNameIconButton.topAnchor.constraint(equalTo: displayName.topAnchor),
            changeDisplayNameIconButton.trailingAnchor.constraint(equalTo: displayName.trailingAnchor, constant: 25),
            changeDisplayNameIconButton.heightAnchor.constraint(equalToConstant: 20),
            changeDisplayNameIconButton.widthAnchor.constraint(equalToConstant: 20),
            
            displayName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 15),
            displayName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            displayName.heightAnchor.constraint(equalToConstant: 40),
            
            signOutButton.topAnchor.constraint(equalTo: displayName.bottomAnchor, constant: 25),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
            signOutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            signOutButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -25),
        ])
    }
}

extension ProfileSettingsViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImage.image = image
            
            let data = image.jpegData(compressionQuality: 0.8)
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            if let data = data {
                Task { [weak self] in
                    self?.loadingIndicator()
                    await self?.uploadChangedImage(imageData: data)
                    self?.removeLoadingIndicator()
                }
            }
        
        }
        
        dismiss(animated: true)
    }
    
}
