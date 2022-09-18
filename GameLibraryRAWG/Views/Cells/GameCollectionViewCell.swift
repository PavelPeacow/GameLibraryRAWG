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
        gameCover.translatesAutoresizingMaskIntoConstraints = false
        gameCover.clipsToBounds = true
        return gameCover
    }()
    
    private let gameLabel: UILabel = {
        let gameLabel = UILabel()
        gameLabel.translatesAutoresizingMaskIntoConstraints = false
        gameLabel.textAlignment = .center
        gameLabel.numberOfLines = 0
        gameLabel.adjustsFontSizeToFitWidth = true
        gameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return gameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(gameCover)
        contentView.addSubview(gameLabel)
        
        setConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: Game) {
        guard let url = URL(string: model.background_image) else { return }
        
        gameCover.sd_imageIndicator = SDWebImageActivityIndicator.large
        gameCover.sd_setImage(with: url)
        
        gameLabel.text = model.name
    }
    
    
}

extension GameCollectionViewCell {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            gameCover.topAnchor.constraint(equalTo: contentView.topAnchor),
            gameCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gameCover.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gameCover.bottomAnchor.constraint(equalTo: gameLabel.topAnchor),
            
            gameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gameLabel.heightAnchor.constraint(equalToConstant: 20),
            gameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
}
