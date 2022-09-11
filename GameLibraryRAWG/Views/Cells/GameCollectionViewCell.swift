//
//  GameCollectionViewCell.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 27.08.2022.
//

import UIKit
import SDWebImage

class GameCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "GameCollectionViewCell"
    
    private let gameCover: UIImageView = {        
        let gameCover = UIImageView()
        gameCover.contentMode = .scaleAspectFill
        gameCover.clipsToBounds = true
        return gameCover
    }()
    
    private let metacriticLabel: UILabel = {
        let metacriticLabel = UILabel()
        metacriticLabel.translatesAutoresizingMaskIntoConstraints = false
        metacriticLabel.backgroundColor = .systemBackground
        metacriticLabel.layer.cornerRadius = 25
        metacriticLabel.layer.borderColor = UIColor.yellow.cgColor
        metacriticLabel.layer.borderWidth = 2
        metacriticLabel.clipsToBounds = true
        metacriticLabel.textAlignment = .center
        return metacriticLabel
    }()
    
    private let gameLabel: UILabel = {
        let gameLabel = UILabel()
        gameLabel.translatesAutoresizingMaskIntoConstraints = false
        gameLabel.textAlignment = .center
        gameLabel.numberOfLines = 2
        gameLabel.adjustsFontSizeToFitWidth = true
        gameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        gameLabel.backgroundColor = .systemBackground.withAlphaComponent(0.5)
        return gameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(gameCover)
        contentView.addSubview(metacriticLabel)
        contentView.addSubview(gameLabel)
        
        setConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gameCover.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: Game) {
        guard let url = URL(string: model.background_image) else { return }
        
        gameCover.sd_imageIndicator = SDWebImageActivityIndicator.large
        gameCover.sd_setImage(with: url)
        
        gameLabel.text = model.name
        
        if let metacritic = model.metacritic {
            //strange bug appears when i dont use isHiddin = false
            metacriticLabel.isHidden = false
            metacriticLabel.text = "\(metacritic)"
        } else {
            metacriticLabel.isHidden = true
        }
        
    }
    
    
}

extension GameCollectionViewCell {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            metacriticLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            metacriticLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            metacriticLabel.heightAnchor.constraint(equalToConstant: 50),
            metacriticLabel.widthAnchor.constraint(equalToConstant: 50),
            
            gameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gameLabel.heightAnchor.constraint(equalToConstant: 20),
            gameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
}
