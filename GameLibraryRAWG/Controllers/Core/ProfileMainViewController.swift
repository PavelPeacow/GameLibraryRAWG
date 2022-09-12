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
                }
                
                
            }
        }
    }
    
}

//MARK: CollcetionView settings
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
        
        loadingIndicator()
        
        APICaller.shared.fetchMainGameDetails(with: favouritesGames[indexPath.item].slug) { [weak self] result in
            self?.removeLoadingIndicatior()
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
