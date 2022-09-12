//
//  ProfileMainViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 09.09.2022.
//

import UIKit

class ProfileMainViewController: UIViewController {
    
    private var favouritesGames = [Game]()
        
    private let gamesFavouritesCollection: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(section: .profile())
        
        let gamesFavouritesCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        gamesFavouritesCollection.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: GameCollectionViewCell.identifier)
        
        gamesFavouritesCollection.register(ProfileCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileCollectionReusableView.identifier)
        return gamesFavouritesCollection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(signOutButton))
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(gamesFavouritesCollection)
        
        setDelegates()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFirestoreData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gamesFavouritesCollection.frame = view.bounds
    }
    
    @objc func signOutButton() {
        try? FirebaseManager.shared.auth.signOut()
        navigationController?.setViewControllers([ProfileAuthorizationViewController()], animated: true)
    }
    
    private func setDelegates() {
        gamesFavouritesCollection.delegate = self
        gamesFavouritesCollection.dataSource = self
    }
    
    private func fetchFirestoreData() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }

        loadingIndicator()
        
        FirebaseManager.shared.firestore.collection("userid \(uid)").getDocuments { [weak self] snapshot, error in
            self?.removeLoadingIndicatior()
            guard error == nil else {
                print("Error when trying get user documents")
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
                    print(self?.favouritesGames ?? "")
                    self?.gamesFavouritesCollection.reloadData()
                }
                
                
            }
        }
    }
    
}

extension ProfileMainViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
//            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
//            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
//            profileImage.heightAnchor.constraint(equalToConstant: 90),
//            profileImage.widthAnchor.constraint(equalToConstant: 90),
//
//            userProfileName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
//            userProfileName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15),
//            userProfileName.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
//
//            gamesAddCount.topAnchor.constraint(equalTo: userProfileName.bottomAnchor, constant: 30),
//            gamesAddCount.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15),
            
//            gamesFavouritesCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            gamesFavouritesCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
//            gamesFavouritesCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
//            gamesFavouritesCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ProfileMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favouritesGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.identifier, for: indexPath) as! GameCollectionViewCell
        cell.configure(with: favouritesGames[indexPath.item])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileCollectionReusableView.identifier, for: indexPath) as! ProfileCollectionReusableView
        
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = GameDetailViewController()
        
        APICaller.shared.fetchMainGameDetails(with: favouritesGames[indexPath.item].slug) { [weak self] result in
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