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
    
    private let imageTrailer: UIImageView = {
        let imageTraler = UIImageView()
        imageTraler.translatesAutoresizingMaskIntoConstraints = false
        imageTraler.clipsToBounds = true
        imageTraler.contentMode = .scaleAspectFill
        return imageTraler
    }()
    
    private let name: UILabel = {
       let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textAlignment = .center
        name.numberOfLines = 2
        name.adjustsFontSizeToFitWidth = true
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.backgroundColor = .white.withAlphaComponent(0.5)
        return name
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(name)
        contentView.addSubview(imageTrailer)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: GameTrailerModel) {
        guard let url = URL(string: model.preview) else { return }
        
        name.text = model.name
        
        imageTrailer.sd_imageIndicator = SDWebImageActivityIndicator.large
        imageTrailer.sd_setImage(with: url)
    }
 
    func setConstraints() {
        NSLayoutConstraint.activate([
            imageTrailer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageTrailer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageTrailer.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageTrailer.bottomAnchor.constraint(equalTo: name.topAnchor),
            
            
            name.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            name.heightAnchor.constraint(equalToConstant: 20),
            name.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
}
