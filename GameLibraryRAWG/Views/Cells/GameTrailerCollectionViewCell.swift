//
//  GameTrailerCollectionViewCell.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 06.09.2022.
//

import UIKit
import SDWebImage

class GameTrailerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "GameTrailerCollectionViewCell"
    
    private let trailerImage: UIImageView = {
        let imageTraler = UIImageView()
        imageTraler.translatesAutoresizingMaskIntoConstraints = false
        imageTraler.clipsToBounds = true
        imageTraler.alpha = 0.25
        imageTraler.contentMode = .scaleAspectFill
        return imageTraler
    }()
    
    private let trailerName: UILabel = {
       let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textAlignment = .center
        name.numberOfLines = 2
        name.adjustsFontSizeToFitWidth = true
        name.font = UIFont.boldSystemFont(ofSize: 16)
        return name
    }()
    
    private let trailerPlayBackground: UIView = {
        let trailerPlayImage = UIView()
        trailerPlayImage.translatesAutoresizingMaskIntoConstraints = false
        trailerPlayImage.backgroundColor = .gray.withAlphaComponent(0.25)
        return trailerPlayImage
    }()
    
    private let trailerPlayIcon: UIImageView = {
        let trailerPlayIcon = UIImageView()
        trailerPlayIcon.translatesAutoresizingMaskIntoConstraints = false
        trailerPlayIcon.image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 60))
        trailerPlayIcon.contentMode = .scaleAspectFill
        return trailerPlayIcon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(trailerPlayBackground)
        trailerPlayBackground.addSubview(trailerPlayIcon)
        
        trailerPlayBackground.addSubview(trailerName)
        trailerPlayBackground.addSubview(trailerImage)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: GameTrailer) {
        guard let url = URL(string: model.preview) else { return }
        
        trailerName.text = model.name
        
        trailerImage.sd_imageIndicator = SDWebImageActivityIndicator.large
        trailerImage.sd_setImage(with: url)
    }
 

}

extension GameTrailerCollectionViewCell {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            trailerPlayBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trailerPlayBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trailerPlayBackground.topAnchor.constraint(equalTo: contentView.topAnchor),
            trailerPlayBackground.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            trailerPlayBackground.bottomAnchor.constraint(equalTo: trailerName.topAnchor),
            
            trailerPlayIcon.centerXAnchor.constraint(equalTo: trailerPlayBackground.centerXAnchor),
            trailerPlayIcon.centerYAnchor.constraint(equalTo: trailerPlayBackground.centerYAnchor),
            
            trailerImage.leadingAnchor.constraint(equalTo: trailerPlayBackground.leadingAnchor),
            trailerImage.trailingAnchor.constraint(equalTo: trailerPlayBackground.trailingAnchor),
            trailerImage.topAnchor.constraint(equalTo: trailerPlayBackground.topAnchor),
            trailerImage.bottomAnchor.constraint(equalTo: trailerName.topAnchor),
            
            
            trailerName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            trailerName.heightAnchor.constraint(equalToConstant: 20),
            trailerName.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
}
