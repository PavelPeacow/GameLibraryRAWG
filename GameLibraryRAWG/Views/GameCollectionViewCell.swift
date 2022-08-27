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
    
    private let metaCriticLabel: UILabel = {
        let metaCriticLabel = UILabel()
        metaCriticLabel.translatesAutoresizingMaskIntoConstraints = false
        return metaCriticLabel
    }()
    
    private let gameLabel: UILabel = {
        let gameLabel = UILabel()
        gameLabel.translatesAutoresizingMaskIntoConstraints = false
        gameLabel.textAlignment = .center
        gameLabel.numberOfLines = 2
        gameLabel.adjustsFontSizeToFitWidth = true
        gameLabel.backgroundColor = .black.withAlphaComponent(0.5)
        return gameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(gameCover)
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
        
        gameCover.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        gameCover.sd_setImage(with: url)
        
        gameLabel.text = model.name
    }
    
    
}

extension GameCollectionViewCell {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            gameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            gameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            gameLabel.heightAnchor.constraint(equalToConstant: 40),
            gameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
}
