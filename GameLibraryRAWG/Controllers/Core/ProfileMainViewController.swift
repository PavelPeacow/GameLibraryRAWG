//
//  ProfileMainViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 09.09.2022.
//

import UIKit

class ProfileMainViewController: UIViewController, ActivityIndicator {
    
    //MARK: PROPERTIES
    private var favouriteGames = [Game]()
    
    private lazy var userDisplayName = ""
    private lazy var userImageURL = Data()
    
    //MARK: VIEWS
    private let favouriteGamesCollection: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(section: .profile())
        
        let gamesFavouritesCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        gamesFavouritesCollection.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: GameCollectionViewCell.identifier)
        
        gamesFavouritesCollection.register(ProfileCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileCollectionReusableView.identifier)
        return gamesFavouritesCollection
    }()
    
    //navBar item
    private lazy var settingsNavBarItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(goToSettingsProfileView))

    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(favouriteGamesCollection)
        
        setDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsNavBarItem.isEnabled = false
   
        Task { [weak self] in
            self?.loadingIndicator()
            await self?.fetchProfileData()
            self?.settingsNavBarItem.isEnabled = true
            self?.removeLoadingIndicator()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favouriteGamesCollection.frame = view.bounds
    }
        
    private func setDelegates() {
        favouriteGamesCollection.delegate = self
        favouriteGamesCollection.dataSource = self
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = settingsNavBarItem
    }
    
    @objc func goToSettingsProfileView() {
        let vc = ProfileSettingsViewController()
        vc.profileImage.image = UIImage(data: userImageURL)
        vc.displayName.text = userDisplayName
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: Firebase api calls
extension ProfileMainViewController {
    
    private func fetchProfileData() async {
        //parallel calls
        async let firestoreData = FirebaseManager.shared.fetchFirestoreData()
        async let userImageData = FirebaseManager.shared.fetchUserImage()
        async let userNameData = FirebaseManager.shared.fetchUserNameDisplay()
        
        do {
            userDisplayName = try await userNameData
            userImageURL = try await userImageData

            favouriteGames = try await firestoreData
            DispatchQueue.main.async { [weak self] in
                self?.favouriteGamesCollection.reloadData()
            }
            
        } catch let error {
            print(error)
        }
        
    }
}

//MARK: CollcetionView settings
extension ProfileMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if favouriteGames.isEmpty {
            collectionView.setEmptyMessageInCollectionView("No favourite games added yet😉")
            collectionView.isScrollEnabled = false
        } else {
            collectionView.restoreCollectionViewBackground()
            collectionView.isScrollEnabled = true
        }
        return favouriteGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.identifier, for: indexPath) as! GameCollectionViewCell
        cell.configure(with: favouriteGames[indexPath.item])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileCollectionReusableView.identifier, for: indexPath) as! ProfileCollectionReusableView

        let model = GameFavouritesProfileViewModel(profileName: userDisplayName, gamesCount: favouriteGames.count, imageData: userImageURL)
        header.configure(with: model)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = GameDetailViewController()
        
        loadingIndicator()
        settingsNavBarItem.isEnabled = false
        
        APICaller.shared.fetchMainGameDetails(with: favouriteGames[indexPath.item].slug) { [weak self] result in
            self?.removeLoadingIndicator()
            self?.settingsNavBarItem.isEnabled = true
            switch result {
            case .success(let gameDetail):
                DispatchQueue.main.async {
                    vc.configure(with: gameDetail, game: self!.favouriteGames[indexPath.item])
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
