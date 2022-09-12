//
//  ProfileCollectionReusableView.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 11.09.2022.
//

import UIKit

class ProfileCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ProfileCollectionReusableView"
    
    private let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.image = UIImage(named: "cat")
        profileImage.contentMode = .scaleToFill
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor.systemBackground.cgColor
        profileImage.layer.cornerRadius = 15
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        return profileImage
    }()
    
    private let userProfileName: UILabel = {
        let userProfileName = UILabel()
        userProfileName.text = "Profile Name: Some_Profile_Name_I_Guess_LOL"
        userProfileName.numberOfLines = 2
        userProfileName.backgroundColor = .red
        userProfileName.translatesAutoresizingMaskIntoConstraints = false
        return userProfileName
    }()
    
    private let gamesAddCount: UILabel = {
        let gamesAddCount = UILabel()
        gamesAddCount.text = "Games add to favourites: 5"
        gamesAddCount.translatesAutoresizingMaskIntoConstraints = false
        return gamesAddCount
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        addSubview(profileImage)
        addSubview(userProfileName)
        addSubview(gamesAddCount)
        
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileCollectionReusableView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            profileImage.heightAnchor.constraint(equalToConstant: 90),
            profileImage.widthAnchor.constraint(equalToConstant: 90),
            
            userProfileName.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            userProfileName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15),
            userProfileName.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            gamesAddCount.topAnchor.constraint(equalTo: userProfileName.bottomAnchor, constant: 30),
            gamesAddCount.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15),
        ])
    }

}
