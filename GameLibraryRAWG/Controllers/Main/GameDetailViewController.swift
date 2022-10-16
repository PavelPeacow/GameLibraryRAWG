//
//  GameDetailViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 29.08.2022.
//

import UIKit
import SDWebImage
import AVFoundation
import AVKit

class GameDetailViewController: UIViewController, ActivityIndicator {
    
    //MARK: PROPERTIES
    //game that saves in firestore
    public var game: Game!
    private var gameDetail: GameDetail!
    private var screenshots = [GameScreenshot]()
    private var gameTrailers = [GameTrailer]()
    private var gamesStoresLinks = [String]()
    
    //MARK: VIEWS
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let gameCover: UIImageView = {
        let gameCover = UIImageView()
        gameCover.translatesAutoresizingMaskIntoConstraints = false
        gameCover.contentMode = .scaleAspectFill
        gameCover.clipsToBounds = true
        return gameCover
    }()
    
    private let metacriticLabel: UILabel = {
        let metacriticLabel = UILabel()
        metacriticLabel.translatesAutoresizingMaskIntoConstraints = false
        metacriticLabel.textColor = .white
        metacriticLabel.backgroundColor = .black
        metacriticLabel.layer.cornerRadius = 25
        metacriticLabel.layer.borderColor = UIColor.systemYellow.cgColor
        metacriticLabel.layer.borderWidth = 2
        metacriticLabel.clipsToBounds = true
        metacriticLabel.textAlignment = .center
        return metacriticLabel
    }()
    
    private let gameName: UILabel = {
        let gameName = UILabel()
        gameName.font = UIFont.boldSystemFont(ofSize: 18)
        gameName.numberOfLines = 0
        gameName.textAlignment = .center
        gameName.translatesAutoresizingMaskIntoConstraints = false
        return gameName
    }()
    
    private let gameDescription: UILabel = {
        let gameDescription = UILabel()
        gameDescription.translatesAutoresizingMaskIntoConstraints = false
        gameDescription.numberOfLines = 0
        return gameDescription
    }()
    
    private let gameAboutContainer: UIView = {
        let gameAboutContainer = UIView()
        gameAboutContainer.translatesAutoresizingMaskIntoConstraints = false
        return gameAboutContainer
    }()
    
    private let gameRelease: GameFeautureView = GameFeautureView()
    
    private let gameRating: GameFeautureView = GameFeautureView()
    
    private let gameGenre: GameFeautureView = GameFeautureView()
    
    private let gameDeveloper: GameFeautureView = GameFeautureView()
    
    private let gamePublisher: GameFeautureView = GameFeautureView()
    
    private let imageCollectionSlider: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 260, height: 200)
        
        let imageCollectionSlider = UICollectionView(frame: .zero, collectionViewLayout: layout)
        imageCollectionSlider.translatesAutoresizingMaskIntoConstraints = false
        imageCollectionSlider.showsHorizontalScrollIndicator = false
        imageCollectionSlider.register(SliderCollectionViewCell.self, forCellWithReuseIdentifier: SliderCollectionViewCell.identifier)
        return imageCollectionSlider
    }()
    
    private let gameTrailersCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 260, height: 200)
        
        let gameTrailersCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        gameTrailersCollection.translatesAutoresizingMaskIntoConstraints = false
        gameTrailersCollection.showsHorizontalScrollIndicator = false
        gameTrailersCollection.register(GameTrailerCollectionViewCell.self, forCellWithReuseIdentifier: GameTrailerCollectionViewCell.identifier)
        return gameTrailersCollection
    }()
    
    private let storeCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 110, height: 100)
        
        let storeCollection = DynamicCollectionView(frame: .zero, collectionViewLayout: layout)
        storeCollection.translatesAutoresizingMaskIntoConstraints = false
        storeCollection.isScrollEnabled = false
        storeCollection.register(GameStoreCollectionViewCell.self, forCellWithReuseIdentifier: GameStoreCollectionViewCell.identifier)
        return storeCollection
    }()
    
    private let whereToBuyLabel: UILabel = {
        let whereToBuyLabel = UILabel()
        whereToBuyLabel.translatesAutoresizingMaskIntoConstraints = false
        whereToBuyLabel.text = "Where to buy"
        whereToBuyLabel.font = UIFont.boldSystemFont(ofSize: 18)
        return whereToBuyLabel
    }()
    
    //NavBar items
    
    private lazy var deleteGameNavBarItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(deleteGame))
    
    private lazy var addGameNavBarItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(addGame))
    
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(gameCover)
        gameCover.addSubview(metacriticLabel)
        
        scrollView.addSubview(gameName)
        
        scrollView.addSubview(gameDescription)
        
        scrollView.addSubview(gameTrailersCollection)
        
        scrollView.addSubview(imageCollectionSlider)
        
        scrollView.addSubview(whereToBuyLabel)
        scrollView.addSubview(storeCollection)
        
        scrollView.addSubview(gameAboutContainer)
        
        gameAboutContainer.addSubview(gameRelease)
        gameAboutContainer.addSubview(gameRating)
        gameAboutContainer.addSubview(gameGenre)
        gameAboutContainer.addSubview(gameDeveloper)
        gameAboutContainer.addSubview(gamePublisher)
        
        view.backgroundColor = .systemBackground
        
        fetchGameTrailers()
        fetchGameScreenshots()
        fetchGameStores()
        
        setDelegates()
        setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavBar()
    }
    
    private func setDelegates() {
        imageCollectionSlider.delegate = self
        imageCollectionSlider.dataSource = self
        
        storeCollection.delegate = self
        storeCollection.dataSource = self
        
        gameTrailersCollection.delegate = self
        gameTrailersCollection.dataSource = self
    }
    
    //MARK: Checking document existing in firestore
    private func configureNavBar() {
        Task { [weak self] in
            self?.loadingIndicator()
            await isGameAddedToFavourite(game: game)
            self?.removeLoadingIndicator()
        }
    }
    
    //MARK: Saving game to firestore
    @objc func addGame() {
        AddGameStateAlert.showGameStateAlert(on: self, with: game, onCompletion: { result in
            Task { [weak self] in
                self?.navigationItem.rightBarButtonItem?.isEnabled = false
                self?.loadingIndicator()
                
                await self?.addGameToFavourite(add: result)
                self?.game = result
                self?.removeLoadingIndicator()
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
                
                self?.navigationItem.rightBarButtonItem = self?.deleteGameNavBarItem
            }
        })
    }
    
    //MARK: Deleting game from firestore
    @objc func deleteGame() {
        RemoveGameStateAlert.showGameStateAlert(on: self, with: game) { result in
            Task { [weak self] in
                self?.navigationItem.rightBarButtonItem?.isEnabled = false
                self?.loadingIndicator()
                
                if result.gameState == nil {
                    await self?.deleteGameFromFavourite(delete: result)
                    self?.navigationItem.rightBarButtonItem = self?.addGameNavBarItem
                } else {
                    await self?.addGameToFavourite(add: result)
                    self?.navigationItem.rightBarButtonItem = self?.deleteGameNavBarItem
                }
                
                self?.game = result
                
                self?.removeLoadingIndicator()
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
                
            }
        }
    }
    
    //MARK: CONFIGURE
    public func configure(with model: GameDetail, game: Game) {
        guard let url = URL(string: model.background_image ?? "") else { return }
        
        gameCover.sd_imageIndicator = SDWebImageActivityIndicator.large
        gameCover.sd_setImage(with: url)
        
        gameDetail = model
        
        self.game = game
        
        gameName.text = model.name
        
        if let metacritic = model.metacritic {
            metacriticLabel.text = String(metacritic)
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.metacriticLabel.removeFromSuperview()
            }
        }
        
        gameDescription.text = model.description_raw
        
        let gameReleaseModel = GameFeaturesViewModel(gameFeatureTitle: "Release", gameFeatureDescr: model.released ?? "TBA")
        gameRelease.configure(with: gameReleaseModel)
        
        let gameRatingModel = GameFeaturesViewModel(gameFeatureTitle: "Rating", gameFeatureDescr: String(model.rating ?? 0))
        gameRating.configure(with: gameRatingModel)
        
        let gameGenreModel = GameFeaturesViewModel(gameFeatureTitle: "Genres", gameFeatureDescr: model.genres.map({ $0.name}).joined(separator: ", "))
        gameGenre.configure(with: gameGenreModel)
        
        let gameDeveloperModel = GameFeaturesViewModel(gameFeatureTitle: "Developer", gameFeatureDescr: model.developers.map({ $0.name}).joined(separator: ", "))
        gameDeveloper.configure(with: gameDeveloperModel)
        
        let gamePublisherModel = GameFeaturesViewModel(gameFeatureTitle: "Publisher", gameFeatureDescr: model.publishers.map({ $0.name}).joined(separator: ", "))
        gamePublisher.configure(with: gamePublisherModel)
    }
    
}

//MARK: Firebase async calls
extension GameDetailViewController {
    
    private func addGameToFavourite(add game: Game) async {
        do {
            let result = try await FirebaseManager.shared.addGameToFavourite(add: game)
            print(result)
        } catch let error {
            print(error)
        }
    }
    
    private func deleteGameFromFavourite(delete game: Game) async {
        do {
            let result = try await FirebaseManager.shared.deleteGameFromFavourite(delete: game)
            print(result)
        } catch let error {
            print(error)
        }
    }
    
    private func isGameAddedToFavourite(game: Game) async {
        do {
            let result = try await FirebaseManager.shared.fetchGameFromFirestore(game: game)
            
            DispatchQueue.main.async { [weak self] in
                self?.game = result
                self?.navigationItem.rightBarButtonItem = self?.deleteGameNavBarItem
            }
            
        } catch let error {
            print(error)
            if error as! FirebaseErrors == FirebaseErrors.ErrorGetGames {
                DispatchQueue.main.async { [weak self] in
                    self?.navigationItem.rightBarButtonItem = self?.addGameNavBarItem
                }
            }
        }
    }
    
}

//MARK: API Results
extension GameDetailViewController {
    
    private func fetchGameScreenshots() {
        APICaller.shared.fetchSpecificGameDetails(with: gameDetail.slug, endpoint: APIEndpoints.screenshots, expecting: GameScreenshotResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.screenshots = response.results
                    self?.imageCollectionSlider.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchGameStores() {
        APICaller.shared.fetchSpecificGameDetails(with: gameDetail.slug, endpoint: APIEndpoints.stores, expecting: GameStoreResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    
                    //if game has store, execute
                    if !response.results.isEmpty {
                        let urls = response.results.map({ $0.url })
                        print(urls)
                        self?.gamesStoresLinks = urls
                        self?.storeCollection.reloadData()
                    } else {
                        self?.storeCollection.removeFromSuperview()
                        self?.whereToBuyLabel.removeFromSuperview()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchGameTrailers() {
        APICaller.shared.fetchSpecificGameDetails(with: gameDetail.slug, endpoint: APIEndpoints.movies, expecting: GameTrailerResponse.self) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async { [weak self] in
                    if !response.results.isEmpty {
                        self?.gameTrailers = response.results
                        self?.gameTrailersCollection.reloadData()
                    } else {
                        self?.gameTrailersCollection.removeFromSuperview()
                    }
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

//MARK: Constraints
extension GameDetailViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            //game image
            gameCover.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameCover.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 5),
            gameCover.heightAnchor.constraint(equalToConstant: 200),
            gameCover.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            gameCover.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            //game title
            gameName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameName.topAnchor.constraint(equalTo: gameCover.bottomAnchor, constant: 10),
            gameName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            gameName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            //metacritic
            metacriticLabel.topAnchor.constraint(equalTo: gameCover.topAnchor,constant: 15),
            metacriticLabel.heightAnchor.constraint(equalToConstant: 50),
            metacriticLabel.widthAnchor.constraint(equalToConstant: 50),
            metacriticLabel.trailingAnchor.constraint(equalTo: gameCover.trailingAnchor, constant: -15),
            
            //description
            gameDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameDescription.topAnchor.constraint(equalTo: gameName.bottomAnchor, constant: 30),
            gameDescription.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            gameDescription.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            
            gameTrailersCollection.topAnchor.constraint(equalTo: gameDescription.bottomAnchor, constant: 30),
            gameTrailersCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            gameTrailersCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            gameTrailersCollection.heightAnchor.constraint(equalToConstant: 200),
            
            
            //slider
            imageCollectionSlider.topAnchor.constraint(equalTo: gameTrailersCollection.bottomAnchor, constant: 30),
            imageCollectionSlider.topAnchor.constraint(equalTo: gameDescription.bottomAnchor, constant: 30).withPriority(.defaultLow),
            imageCollectionSlider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            imageCollectionSlider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            imageCollectionSlider.heightAnchor.constraint(equalToConstant: 200),
            
            whereToBuyLabel.topAnchor.constraint(equalTo: gameTrailersCollection.bottomAnchor, constant: 15).withPriority(.defaultLow),
            whereToBuyLabel.topAnchor.constraint(equalTo: imageCollectionSlider.bottomAnchor, constant: 15),
            whereToBuyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            whereToBuyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            storeCollection.topAnchor.constraint(equalTo: whereToBuyLabel.bottomAnchor, constant: 30),
            storeCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            storeCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            
            //container with game futures inside
            gameAboutContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameAboutContainer.topAnchor.constraint(equalTo: storeCollection.bottomAnchor, constant: 10),
            gameAboutContainer.topAnchor.constraint(equalTo: imageCollectionSlider.bottomAnchor, constant: 10).withPriority(.defaultLow),
            gameAboutContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            gameAboutContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            gameAboutContainer.heightAnchor.constraint(equalToConstant: 300),
            
            //first column
            gameRelease.topAnchor.constraint(equalTo: gameAboutContainer.topAnchor, constant: 30),
            gameRelease.leadingAnchor.constraint(equalTo: gameAboutContainer.leadingAnchor, constant: 15),
            gameRelease.widthAnchor.constraint(equalToConstant: 120),
            
            gameGenre.topAnchor.constraint(equalTo: gameRelease.bottomAnchor, constant: 30),
            gameGenre.leadingAnchor.constraint(equalTo: gameAboutContainer.leadingAnchor, constant: 15),
            gameGenre.widthAnchor.constraint(equalToConstant: 120),
            
            //second column
            gameRating.topAnchor.constraint(equalTo: gameAboutContainer.topAnchor, constant: 30),
            gameRating.trailingAnchor.constraint(equalTo: gameAboutContainer.trailingAnchor, constant: -15),
            gameRating.widthAnchor.constraint(equalToConstant: 120),
            
            gameDeveloper.topAnchor.constraint(equalTo: gameRating.bottomAnchor, constant: 30),
            gameDeveloper.trailingAnchor.constraint(equalTo: gameAboutContainer.trailingAnchor, constant: -15),
            gameDeveloper.widthAnchor.constraint(equalToConstant: 120),
            
            gamePublisher.topAnchor.constraint(equalTo: gameDeveloper.bottomAnchor, constant: 30),
            gamePublisher.trailingAnchor.constraint(equalTo: gameAboutContainer.trailingAnchor, constant: -15),
            gamePublisher.widthAnchor.constraint(equalToConstant: 120),
            gamePublisher.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -15),
        ])
    }
}

//MARK: CollcetionView settings
extension GameDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            
        case gameTrailersCollection:
            return gameTrailers.count
            
        case imageCollectionSlider:
            return screenshots.count
            
        case storeCollection:
            return gamesStoresLinks.count
            
        default: fatalError("GameDetailView count")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case gameTrailersCollection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameTrailerCollectionViewCell.identifier, for: indexPath) as! GameTrailerCollectionViewCell
            
            cell.configure(with: gameTrailers[indexPath.item])
            return cell
            
        case imageCollectionSlider:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SliderCollectionViewCell.identifier, for: indexPath) as! SliderCollectionViewCell
            
            cell.configure(with: screenshots[indexPath.item].image)
            return cell
            
        case storeCollection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameStoreCollectionViewCell.identifier, for: indexPath) as! GameStoreCollectionViewCell
            
            let verifiedStore = checkStores(with: gamesStoresLinks[indexPath.item])
            
            cell.configure(store: verifiedStore)
            return cell
            
        default: fatalError("GameDetailView collections")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
            
        case storeCollection:
            let vc = StoreWebViewViewController()
            
            if gamesStoresLinks[indexPath.item].contains(Stores.appleStore.rawValue) {
                
                if let range = gamesStoresLinks[indexPath.item].range(of: "id") {
                    let id = String(gamesStoresLinks[indexPath.item][range.upperBound..<gamesStoresLinks[indexPath.item].lastIndex(of: "?")!])
                    print(id)
                    
                    if let url = URL(string: "itms-apps://itunes.apple.com/app/\(id)") {
                        UIApplication.shared.open(url)
                    }
                }
            } else {
                vc.storeUrl = gamesStoresLinks[indexPath.item]
                navigationController?.pushViewController(vc, animated: true)
            }
            
        case imageCollectionSlider:
            let vc = ScreenshotPreviewViewController()
            vc.configure(with: screenshots[indexPath.item].image)
            present(vc, animated: true)
            
        case gameTrailersCollection:
            let videoURL = URL(string: gameTrailers[indexPath.item].data.max)
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
                player.volume = 0.5
            }
            
        default:
            fatalError("there no more collectionViews")
        }
        
        
    }
}
