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
    private lazy var userImageURL = ""
    
    //dispatch
    private let dispatchGroup = DispatchGroup()
    
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
        
        loadingIndicator()
        
        fetchFirestoreData()
        fetchUserImageData()
        fetchUserNameData()
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.removeLoadingIndicator()
            self?.settingsNavBarItem.isEnabled = true
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
        guard let url = URL(string: userImageURL) else { return }
        let vc = ProfileSettingsViewController()
        vc.profileImage.sd_setImage(with: url)
        vc.displayName.text = userDisplayName
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: Firebase api calls
extension ProfileMainViewController {
    
    private func fetchFirestoreData() {
        
        dispatchGroup.enter()
        
        FirebaseManager.shared.fetchFirestoreData { [weak self] gameResult in
            switch gameResult {
            case .success(let game):
                DispatchQueue.main.async {
                    self?.favouriteGames = game
                    self?.favouriteGamesCollection.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            self?.dispatchGroup.leave()
        }
    }
    
    private func fetchUserImageData() {
        
        dispatchGroup.enter()
        
        FirebaseManager.shared.fetchUserImage { [weak self] urlResult in
            switch urlResult {
            case .success(let url):
                self?.userImageURL = url.absoluteString
            case .failure(let error):
                print(error)
            }
            self?.dispatchGroup.leave()
        }
    }
    
    private func fetchUserNameData() {
        
        dispatchGroup.enter()
        
        FirebaseManager.shared.fetchUserNameDisplay { [weak self] nameResult in
            switch nameResult {
            case .success(let userName):
                self?.userDisplayName = userName
            case .failure(let error):
                print(error)
            }
            self?.dispatchGroup.leave()
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
        
        APICaller.shared.fetchMainGameDetails(with: favouriteGames[indexPath.item].slug) { [weak self] result in
            self?.removeLoadingIndicator()
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
