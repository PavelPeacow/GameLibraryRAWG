//
//  ProfileMainViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 09.09.2022.
//

import UIKit

class ProfileMainViewController: UIViewController, ActivityIndicator {
    
    //MARK: PROPERTIES
    private var sortedGames = [Game]()
    
    private var allGames = [Game]()
    private var completedGames = [Game]()
    private var playingGames = [Game]()
    private var ownedGames = [Game]()
    private var willPlayGames = [Game]()
    
    private lazy var segmentedControlItems = ["All", "Completed", "Playing", "Owned", "Will Play"]
    
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
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: segmentedControlItems)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(sortGamesWithState(_:)), for: .valueChanged)
        segmentedControl.apportionsSegmentWidthsByContent = true
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemBackground
        return segmentedControl
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
            
            sortGames()
            
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                sortedGames = allGames
            case 1:
                sortedGames = completedGames
            case 2:
                sortedGames = playingGames
            case 3:
                sortedGames = ownedGames
            case 4:
                sortedGames = willPlayGames
            default:
                print("no index")
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.favouriteGamesCollection.reloadData()
            }
            
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
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = settingsNavBarItem
    }
    
    private func sortGames() {
        for favouriteGame in allGames {
            
            switch favouriteGame.gameState {
            case "completed":
                if !completedGames.contains(where: { $0.name == favouriteGame.name }) {
                    completedGames.append(favouriteGame)
                }
            case "playing":
                if !playingGames.contains(where: { $0.name == favouriteGame.name }) {
                    playingGames.append(favouriteGame)
                }
            case "owned":
                if !ownedGames.contains(where: { $0.name == favouriteGame.name }) {
                    ownedGames.append(favouriteGame)
                }
            case "willPlay":
                if !willPlayGames.contains(where: { $0.name == favouriteGame.name }) {
                    willPlayGames.append(favouriteGame)
                }
            default:
                print("no games to add")
            }
        }
    }
    
    @objc func sortGamesWithState(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sortedGames = allGames
            favouriteGamesCollection.reloadData()
        case 1:
            sortedGames = completedGames
            favouriteGamesCollection.reloadData()
        case 2:
            sortedGames = playingGames
            favouriteGamesCollection.reloadData()
        case 3:
            sortedGames = ownedGames
            favouriteGamesCollection.reloadData()
        case 4:
            sortedGames = willPlayGames
            favouriteGamesCollection.reloadData()
        default:
            print("no index")
        }
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
            
            allGames = try await firestoreData
            completedGames.removeAll()
            playingGames.removeAll()
            ownedGames.removeAll()
            willPlayGames.removeAll()
                        
            if allGames.isEmpty {
                favouriteGamesCollection.setEmptyMessageInCollectionView("No games added yet😉")
                favouriteGamesCollection.isScrollEnabled = false
            } else {
                favouriteGamesCollection.restoreCollectionViewBackground()
                favouriteGamesCollection.isScrollEnabled = true
            }
                        
        } catch let error {
            print(error)
        }
        
    }
    
}


//MARK: CollcetionView settings
extension ProfileMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sortedGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.identifier, for: indexPath) as! GameCollectionViewCell
        cell.configure(with: sortedGames[indexPath.item])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileCollectionReusableView.identifier, for: indexPath) as! ProfileCollectionReusableView
        
        let model = GameFavouritesProfileViewModel(profileName: userDisplayName, gamesCount: sortedGames.count, imageData: userImageURL)
        header.configure(with: model)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = GameDetailViewController()
        
        loadingIndicator()
        settingsNavBarItem.isEnabled = false
        
        APICaller.shared.fetchMainGameDetails(with: sortedGames[indexPath.item].slug) { [weak self] result in
            self?.removeLoadingIndicator()
            self?.settingsNavBarItem.isEnabled = true
            switch result {
            case .success(let gameDetail):
                DispatchQueue.main.async {
                    vc.configure(with: gameDetail, game: self!.sortedGames[indexPath.item])
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
