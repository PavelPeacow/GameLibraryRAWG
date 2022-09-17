//
//  ProfileMainViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 09.09.2022.
//

import UIKit

class ProfileMainViewController: UIViewController, ActivityIndicator {
    
    //PROPERTIES
    private var favouritesGames = [Game]()
    
    private var userDisplayName = ""
    private var userImageURL: URL!
    
    //VIEWS
    private let gamesFavouritesCollection: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(section: .profile())
        
        let gamesFavouritesCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        gamesFavouritesCollection.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: GameCollectionViewCell.identifier)
        
        gamesFavouritesCollection.register(ProfileCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileCollectionReusableView.identifier)
        return gamesFavouritesCollection
    }()
    
    private let navBarButtonProfileSettings = UIButton(type: .system)
    private let dispatchGroup = DispatchGroup()
    
    //LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(gamesFavouritesCollection)
        
        setDelegates()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingIndicator()
        fetchFirestoreData()
        fetchUserImage()
        fetchUserNameDisplay()
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.removeLoadingIndicator()
            self?.navBarButtonProfileSettings.isEnabled = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gamesFavouritesCollection.frame = view.bounds
    }
    
    private func configureNavBar() {
        
        navBarButtonProfileSettings.setTitle("Profile Settings", for: .normal)
        
        navBarButtonProfileSettings.addAction(UIAction(handler: { [weak self] _ in
            let vc = ProfileSettingsViewController()
            vc.profileImage.sd_setImage(with: self?.userImageURL)
            vc.displayName.text = self?.userDisplayName
            self?.navigationController?.pushViewController(vc, animated: true)
        }), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navBarButtonProfileSettings)
    }
    
    private func setDelegates() {
        gamesFavouritesCollection.delegate = self
        gamesFavouritesCollection.dataSource = self
    }
    
    private func fetchFirestoreData() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        navBarButtonProfileSettings.isEnabled = false
        
        dispatchGroup.enter()
        FirebaseManager.shared.firestore.collection("Users").document(uid).collection("Games").getDocuments { [weak self] snapshot, error in
            
            guard error == nil else {
                print(FirebaseErrors.ErrorGetUserDocuments)
                return
            }
            
            if let snapshot = snapshot {
                DispatchQueue.main.async {
                    self?.favouritesGames = snapshot.documents.map { doc in
                        return Game(name: doc["name"] as? String ?? "",
                                    slug: doc["slug"] as? String ?? "",
                                    background_image: doc["background_image"] as? String ?? "",
                                    metacritic: doc["metacritic"] as? Int)
                    }
                    
                    self?.gamesFavouritesCollection.reloadData()
                    self?.dispatchGroup.leave()
                }
            }
        }
    }
    

    private func fetchUserImage() {
        dispatchGroup.enter()
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        FirebaseManager.shared.storage.reference().child("Users Images/\(uid)/userAvatar.jpg").downloadURL { [weak self] url, error in
            
            guard error == nil else { print("error url"); return }
            
            DispatchQueue.main.async {
                self?.userImageURL = url
                self?.dispatchGroup.leave()
            }
        }
    }
    
    private func fetchUserNameDisplay() {
        dispatchGroup.enter()
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        FirebaseManager.shared.firestore.collection("Users").document(uid).getDocument { [weak self] snapshot, error in
            guard error == nil else { print(FirebaseErrors.ErrorGetUserDocuments); return }
            
            if let snapshot = snapshot {
                let data = snapshot.get("user_name") as? String ?? "Unknown"
                DispatchQueue.main.async {
                    self?.userDisplayName = data
                    self?.dispatchGroup.leave()
                }
            }
        }
    }
    
}

//MARK: CollcetionView settings
extension ProfileMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if favouritesGames.isEmpty {
            collectionView.setEmptyMessageInCollectionView("No favourite games added yet😉")
            collectionView.isScrollEnabled = false
        } else {
            collectionView.restoreCollectionViewBackground()
            collectionView.isScrollEnabled = true
        }
        return favouritesGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.identifier, for: indexPath) as! GameCollectionViewCell
        cell.configure(with: favouritesGames[indexPath.item])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileCollectionReusableView.identifier, for: indexPath) as! ProfileCollectionReusableView
        
        if let uid = FirebaseManager.shared.auth.currentUser?.uid {
            FirebaseManager.shared.firestore.collection("Users").document(uid).getDocument { [weak self] snapshot, error in
                guard error == nil else { print(FirebaseErrors.ErrorGetUserDocuments); return }
                
                if let snapshot = snapshot {
                    print("loh test 228")
                    let dataName = snapshot.get("user_name") as? String ?? "Unknown"
                    
                    FirebaseManager.shared.storage.reference().child("Users Images/\(uid)/userAvatar.jpg").downloadURL { url, error in
                        
                        guard error == nil else { print("error url"); return }
                        
                        let model = GameFavouritesProfileViewModel(profileName: dataName, gamesCount: self!.favouritesGames.count, imageData: url!)
                        header.configure(with: model)
                    }
                }
            }
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = GameDetailViewController()
        
        loadingIndicator()
        
        APICaller.shared.fetchMainGameDetails(with: favouritesGames[indexPath.item].slug) { [weak self] result in
            self?.removeLoadingIndicator()
            switch result {
            case .success(let gameDetail):
                DispatchQueue.main.async {
                    vc.configure(with: gameDetail, game: self!.favouritesGames[indexPath.item])
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
