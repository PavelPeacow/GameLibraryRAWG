//
//  SearchGameTableViewCell.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 12.09.2022.
//

import UIKit
import SDWebImage

class SearchGameTableViewCell: UITableViewCell {
    
    static let identifier = "SearchGameTableViewCell"
    
    private let gameCover: UIImageView = {
        let gameCover = UIImageView()
        gameCover.contentMode = .scaleAspectFill
        gameCover.translatesAutoresizingMaskIntoConstraints = false
        gameCover.clipsToBounds = true
        return gameCover
    }()
    
    private let gameTitle: UILabel = {
        let gameTitle = UILabel()
        gameTitle.numberOfLines = 0
        gameTitle.adjustsFontSizeToFitWidth = true
        gameTitle.translatesAutoresizingMaskIntoConstraints = false
        gameTitle.textAlignment = .center
        return gameTitle
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(gameCover)
        contentView.addSubview(gameTitle)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: Game) {
        
        guard let url = URL(string: model.background_image) else { return }
        
        gameCover.sd_imageIndicator = SDWebImageActivityIndicator.large
        gameCover.sd_setImage(with: url)
        
        gameTitle.text = model.name
    }
    
}

extension SearchGameTableViewCell {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            gameCover.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            gameCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            gameCover.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            gameCover.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            
            gameTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            gameTitle.leadingAnchor.constraint(equalTo: gameCover.trailingAnchor, constant: 30),
            gameTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
        ])
    }
}
