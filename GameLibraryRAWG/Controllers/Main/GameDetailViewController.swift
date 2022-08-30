//
//  GameDetailViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 29.08.2022.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let gameCover: UIImageView = {
        let gameCover = UIImageView()
        gameCover.translatesAutoresizingMaskIntoConstraints = false
        gameCover.contentMode = .scaleAspectFill
        return gameCover
    }()
    
    private let gameName: UILabel = {
        let gameName = UILabel()
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
//        gameRelease.backgroundColor = .red
        return gameRelease
    }()
    
    private let gameRating: GameFutureView = {
        let gameRating = GameFutureView()
        gameRating.translatesAutoresizingMaskIntoConstraints = false
//        gameRating.backgroundColor = .red
        return gameRating
    }()
   
    private let gameGenre: GameFutureView = {
        let gameGenre = GameFutureView()
        gameGenre.translatesAutoresizingMaskIntoConstraints = false
//        gameGenre.backgroundColor = .red
        return gameGenre
    }()
    
    private let gameDeveloper: GameFutureView = {
        let gameDeveloper = GameFutureView()
        gameDeveloper.translatesAutoresizingMaskIntoConstraints = false
//        gameDeveloper.backgroundColor = .red
        return gameDeveloper
    }()
    
    private let gamePublisher: GameFutureView = {
        let gamePublisher = GameFutureView()
        gamePublisher.translatesAutoresizingMaskIntoConstraints = false
//        gamePublisher.backgroundColor = .red
        return gamePublisher
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)

        scrollView.addSubview(gameCover)
        scrollView.addSubview(gameName)
        scrollView.addSubview(gameDescription)
        scrollView.addSubview(gameAboutContainer)
        
        gameAboutContainer.addSubview(gameRelease)
        gameAboutContainer.addSubview(gameRating)
        gameAboutContainer.addSubview(gameGenre)
        gameAboutContainer.addSubview(gameDeveloper)
        gameAboutContainer.addSubview(gamePublisher)
        
        view.backgroundColor = .systemBackground
        
        
        setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
    }
    
    public func configure(with model: GameDetail) {
        guard let url = URL(string: model.background_image ?? "") else { return }
        
        gameCover.sd_setImage(with: url)
        
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


}

extension GameDetailViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            gameCover.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameCover.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 50),
            gameCover.heightAnchor.constraint(equalToConstant: 200),
            gameCover.widthAnchor.constraint(equalToConstant: 200),
            
            gameName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameName.topAnchor.constraint(equalTo: gameCover.bottomAnchor, constant: 10),
            
            gameDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameDescription.topAnchor.constraint(equalTo: gameName.bottomAnchor, constant: 30),
            gameDescription.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            gameDescription.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            
            
            gameAboutContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameAboutContainer.topAnchor.constraint(equalTo: gameDescription.bottomAnchor, constant: 10),
            gameAboutContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            gameAboutContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            gameAboutContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            gameAboutContainer.heightAnchor.constraint(equalToConstant: 300),
            
            gameRelease.topAnchor.constraint(equalTo: gameAboutContainer.topAnchor, constant: 30),
            gameRelease.leadingAnchor.constraint(equalTo: gameAboutContainer.leadingAnchor, constant: 15),
            gameRelease.heightAnchor.constraint(equalToConstant: 60),
            gameRelease.widthAnchor.constraint(equalToConstant: 120),
            
            gameGenre.topAnchor.constraint(equalTo: gameRelease.bottomAnchor, constant: 30),
            gameGenre.leadingAnchor.constraint(equalTo: gameAboutContainer.leadingAnchor, constant: 15),
            gameGenre.heightAnchor.constraint(equalToConstant: 60),
            gameGenre.widthAnchor.constraint(equalToConstant: 120),
            
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
