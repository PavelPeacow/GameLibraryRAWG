//
//  ProfileCollectionReusableView.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 11.09.2022.
//

import UIKit
import SDWebImage

class ProfileCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ProfileCollectionReusableView"
    
    private let profileImage: UIImageView = {
        let profileImage = UIImageView()
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
        userProfileName.numberOfLines = 1
        userProfileName.font = UIFont.preferredFont(forTextStyle: .headline)
        userProfileName.translatesAutoresizingMaskIntoConstraints = false
        return userProfileName
    }()
    
    private let gamesAddCount: UILabel = {
        let gamesAddCount = UILabel()
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
    
    public func configure(with model: GameFavouritesProfileViewModel) {
        userProfileName.text = model.profileName
        gamesAddCount.text = "games added: \(model.gamesCount)"
        
        profileImage.image = UIImage(data: model.imageData)
    }
}

extension ProfileCollectionReusableView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            profileImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            profileImage.heightAnchor.constraint(equalToConstant: 120),
            profileImage.widthAnchor.constraint(equalToConstant: 120),
            
            userProfileName.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 15),
            userProfileName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15),
            userProfileName.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            gamesAddCount.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: -15),
            gamesAddCount.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15),
        ])
    }

}
