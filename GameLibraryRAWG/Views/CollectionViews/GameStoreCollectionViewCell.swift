//
//  GameStoreCollectionViewCell.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 03.09.2022.
//

import UIKit

class GameStoreCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "GameStoreCollectionViewCell"
    
    private let storeImage: UIImageView = {
        let storeImage = UIImageView()
        storeImage.translatesAutoresizingMaskIntoConstraints = false
        storeImage.contentMode = .scaleAspectFit
        return storeImage
    }()
    
    private let storeTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(storeImage)
        contentView.addSubview(storeTitle)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(store: String) {
        storeImage.image = UIImage(named: store)
        storeTitle.text = store
    }
    
}

extension GameStoreCollectionViewCell {
    func setConstraints() {
        NSLayoutConstraint.activate([
            storeImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            storeImage.heightAnchor.constraint(equalToConstant: 50),
            
            
            storeTitle.topAnchor.constraint(equalTo: storeImage.bottomAnchor, constant: 5),
            storeTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            storeTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
    }
}
