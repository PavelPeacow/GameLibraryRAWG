//
//  GameDetailViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 29.08.2022.
//

import UIKit

class GameDetailViewController: UIViewController {
    
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
        return gameDescription
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(gameCover)
        view.addSubview(gameName)
        view.addSubview(gameDescription)
        
        view.backgroundColor = .systemBackground
        
        setConstraints()
    }
    
    public func configure(with model: GameDetail) {
        guard let url = URL(string: model.background_image ?? "") else { return }
        
        gameCover.sd_setImage(with: url)
        
        gameName.text = model.name
        gameDescription.text = model.desctiption
    }


}

extension GameDetailViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            gameCover.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameCover.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            gameCover.heightAnchor.constraint(equalToConstant: 200),
            gameCover.widthAnchor.constraint(equalToConstant: 200),
            
            gameName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameName.topAnchor.constraint(equalTo: gameCover.bottomAnchor, constant: 10),
        ])
    }
}
