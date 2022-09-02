//
//  GameDetailViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 29.08.2022.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    private var screenshots = [GameScreenshot]()
    
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
        
    private let gameRelease: GameFutureView = {
        let gameRelease = GameFutureView()
        gameRelease.translatesAutoresizingMaskIntoConstraints = false
        return gameRelease
    }()
    
    private let gameRating: GameFutureView = {
        let gameRating = GameFutureView()
        gameRating.translatesAutoresizingMaskIntoConstraints = false
        return gameRating
    }()
   
    private let gameGenre: GameFutureView = {
        let gameGenre = GameFutureView()
        gameGenre.translatesAutoresizingMaskIntoConstraints = false
        return gameGenre
    }()
    
    private let gameDeveloper: GameFutureView = {
        let gameDeveloper = GameFutureView()
        gameDeveloper.translatesAutoresizingMaskIntoConstraints = false
        return gameDeveloper
    }()
    
    private let gamePublisher: GameFutureView = {
        let gamePublisher = GameFutureView()
        gamePublisher.translatesAutoresizingMaskIntoConstraints = false
        return gamePublisher
    }()
    
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
    
    private let whereToBuyLabel: UILabel = {
        let whereToBuyLabel = UILabel()
        whereToBuyLabel.translatesAutoresizingMaskIntoConstraints = false
        whereToBuyLabel.isHidden = true
        whereToBuyLabel.text = "Where to buy"
        return whereToBuyLabel
    }()
    
    private let storesStackView: UIStackView = {
        let storeStackView = UIStackView()
        storeStackView.translatesAutoresizingMaskIntoConstraints = false
        storeStackView.axis = .horizontal
        storeStackView.distribution = .equalCentering
        storeStackView.spacing = 5
        return storeStackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)

        scrollView.addSubview(gameCover)
        scrollView.addSubview(gameName)
        scrollView.addSubview(gameDescription)
        scrollView.addSubview(gameAboutContainer)
        scrollView.addSubview(imageCollectionSlider)
        
        scrollView.addSubview(whereToBuyLabel)
        scrollView.addSubview(storesStackView)

        gameAboutContainer.addSubview(gameRelease)
        gameAboutContainer.addSubview(gameRating)
        gameAboutContainer.addSubview(gameGenre)
        gameAboutContainer.addSubview(gameDeveloper)
        gameAboutContainer.addSubview(gamePublisher)
        
        view.backgroundColor = .systemBackground
        
        setDelegates()
        setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
    }
    
    private func setDelegates() {
        imageCollectionSlider.delegate = self
        imageCollectionSlider.dataSource = self
    }
    
    public func configure(with model: GameDetail) {
        guard let url = URL(string: model.background_image ?? "") else { return }
        
        gameCover.sd_setImage(with: url)
        
        APICaller.shared.fetchSpecificGameDetails(with: model.slug, endpoint: APIEndpoints.screenshots, expecting: GameScreenshotResponse.self) { [weak self] result in
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
        
        APICaller.shared.fetchSpecificGameDetails(with: model.slug, endpoint: APIEndpoints.stores, expecting: GameStoreResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    
                    if !response.results.isEmpty {
                        self?.whereToBuyLabel.isHidden = false
                        let urls = response.results.map({ $0.url })
                        print("some urls epta \(urls)")
                        
                        for store in urls {
                            print(store)
                            self?.storesCheck(with: store)
                        }
                    }
                }
               
            case .failure(let error):
                print(error)
            }
        }
        
        gameName.text = model.name
        gameDescription.text = model.description_raw
        
        let gameReleaseModel = GameFutureViewModel(gameFutureTitle: "Release", gameFutureDescr: model.released ?? "TBA")
        gameRelease.configure(with: gameReleaseModel)
        
        let gameRatingModel = GameFutureViewModel(gameFutureTitle: "Rating", gameFutureDescr: String(model.rating ?? 0))
        gameRating.configure(with: gameRatingModel)
        
        let gameGenreModel = GameFutureViewModel(gameFutureTitle: "Genres", gameFutureDescr: model.genres.map({ $0.name}).joined(separator: ", "))
        gameGenre.configure(with: gameGenreModel)
        
        let gameDeveloperModel = GameFutureViewModel(gameFutureTitle: "Developer", gameFutureDescr: model.developers.map({ $0.name}).joined(separator: ", "))
        gameDeveloper.configure(with: gameDeveloperModel)
        
        let gamePublisherModel = GameFutureViewModel(gameFutureTitle: "Publisher", gameFutureDescr: model.publishers.map({ $0.name}).joined(separator: ", "))
        gamePublisher.configure(with: gamePublisherModel)
    }
    
    private func storesCheck(with i: String) {
        if i.contains(Stores.steam.rawValue) {
            
            storesStackView.addArrangedSubview(StoreButton(with: Stores.steam))
            
        } else if i.contains(Stores.microsoft.rawValue) {
            
            storesStackView.addArrangedSubview(StoreButton(with: Stores.microsoft))
            
        } else if i.contains(Stores.playstation.rawValue) {
            
            storesStackView.addArrangedSubview(StoreButton(with: Stores.playstation))
            
        } else if i.contains(Stores.nintendo.rawValue) {
            
            storesStackView.addArrangedSubview(StoreButton(with: Stores.nintendo))
            
        } else if i.contains(Stores.gog.rawValue) {
            
            storesStackView.addArrangedSubview(StoreButton(with: Stores.gog))
            
        } else if i.contains(Stores.appleStore.rawValue) {
            
            storesStackView.addArrangedSubview(StoreButton(with: Stores.appleStore))
            
        } else if i.contains(Stores.googleStore.rawValue) {
            
            storesStackView.addArrangedSubview(StoreButton(with: Stores.googleStore))
            
        } else if i.contains(Stores.epicgames.rawValue) {
            
            storesStackView.addArrangedSubview(StoreButton(with: Stores.epicgames))
            
        }
    }


}

//MARK: Constraints
extension GameDetailViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            //game image
            gameCover.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameCover.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 50),
            gameCover.heightAnchor.constraint(equalToConstant: 200),
            gameCover.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            gameCover.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            //game title
            gameName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameName.topAnchor.constraint(equalTo: gameCover.bottomAnchor, constant: 10),
            gameName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            gameName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            //description
            gameDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameDescription.topAnchor.constraint(equalTo: gameName.bottomAnchor, constant: 30),
            gameDescription.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            gameDescription.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            //slider
            imageCollectionSlider.topAnchor.constraint(equalTo: gameDescription.bottomAnchor, constant: 30),
            imageCollectionSlider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            imageCollectionSlider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            imageCollectionSlider.heightAnchor.constraint(equalToConstant: 200),
            
            whereToBuyLabel.topAnchor.constraint(equalTo: imageCollectionSlider.bottomAnchor, constant: 15),
            whereToBuyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            whereToBuyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            storesStackView.topAnchor.constraint(equalTo: whereToBuyLabel.bottomAnchor, constant: 30),
            storesStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            storesStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            storesStackView.heightAnchor.constraint(equalToConstant: 300),
            
            //container with game futures inside
            gameAboutContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameAboutContainer.topAnchor.constraint(equalTo: storesStackView.bottomAnchor, constant: 10),
            gameAboutContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            gameAboutContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            gameAboutContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            gameAboutContainer.heightAnchor.constraint(equalToConstant: 300),
            
            //first column
            gameRelease.topAnchor.constraint(equalTo: gameAboutContainer.topAnchor, constant: 30),
            gameRelease.leadingAnchor.constraint(equalTo: gameAboutContainer.leadingAnchor, constant: 15),
            gameRelease.heightAnchor.constraint(equalToConstant: 60),
            gameRelease.widthAnchor.constraint(equalToConstant: 120),
            
            gameGenre.topAnchor.constraint(equalTo: gameRelease.bottomAnchor, constant: 30),
            gameGenre.leadingAnchor.constraint(equalTo: gameAboutContainer.leadingAnchor, constant: 15),
            gameGenre.heightAnchor.constraint(equalToConstant: 60),
            gameGenre.widthAnchor.constraint(equalToConstant: 120),
            
            //second column
            gameRating.topAnchor.constraint(equalTo: gameAboutContainer.topAnchor, constant: 30),
            gameRating.trailingAnchor.constraint(equalTo: gameAboutContainer.trailingAnchor, constant: -15),
            gameRating.heightAnchor.constraint(equalToConstant: 60),
            gameRating.widthAnchor.constraint(equalToConstant: 120),
            
            gameDeveloper.topAnchor.constraint(equalTo: gameRating.bottomAnchor, constant: 30),
            gameDeveloper.trailingAnchor.constraint(equalTo: gameAboutContainer.trailingAnchor, constant: -15),
            gameDeveloper.heightAnchor.constraint(equalToConstant: 60),
            gameDeveloper.widthAnchor.constraint(equalToConstant: 120),
            
            gamePublisher.topAnchor.constraint(equalTo: gameDeveloper.bottomAnchor, constant: 30),
            gamePublisher.trailingAnchor.constraint(equalTo: gameAboutContainer.trailingAnchor, constant: -15),
            gamePublisher.heightAnchor.constraint(equalToConstant: 60),
            gamePublisher.widthAnchor.constraint(equalToConstant: 120),
        ])
    }
}

//MARK: Collection slider settings
extension GameDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SliderCollectionViewCell.identifier, for: indexPath) as! SliderCollectionViewCell
        cell.configure(with: screenshots[indexPath.item].image)
        return cell
    }
}
