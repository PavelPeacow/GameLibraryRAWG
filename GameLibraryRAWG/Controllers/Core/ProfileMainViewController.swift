//
//  ProfileMainViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 09.09.2022.
//

import UIKit

class ProfileMainViewController: UIViewController {
    
    private var favouritesGames = [Game]()
    
    private let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.backgroundColor = .orange
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
    
    private let gamesFavouritesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 200)
        
        let gamesFavouritesCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        gamesFavouritesCollection.translatesAutoresizingMaskIntoConstraints = false
        return gamesFavouritesCollection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(profileImage)
        view.addSubview(userProfileName)
        view.addSubview(gamesAddCount)
        view.addSubview(gamesFavouritesCollection)
        	
        setDelegates()
        setConstraints()
    }
    
    func setDelegates() {
        gamesFavouritesCollection.delegate = self
        gamesFavouritesCollection.dataSource = self
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            profileImage.heightAnchor.constraint(equalToConstant: 90),
            profileImage.widthAnchor.constraint(equalToConstant: 90),
            
            userProfileName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            userProfileName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15),
            userProfileName.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            gamesAddCount.topAnchor.constraint(equalTo: userProfileName.bottomAnchor, constant: 30),
            gamesAddCount.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15),
            
            gamesFavouritesCollection.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 30),
            gamesFavouritesCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            gamesFavouritesCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ])
    }
    
    
}

extension ProfileMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favouritesGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.identifier, for: indexPath) as! GameCollectionViewCell
        return cell
        
    }
    
    
}
