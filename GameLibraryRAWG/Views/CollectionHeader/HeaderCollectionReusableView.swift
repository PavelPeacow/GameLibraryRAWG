//
//  HeaderCollectionReusableView.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 28.08.2022.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "HeaderCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(label)
        label.frame = bounds
    }
    
    public func configure(with model: String) {
        label.text = model
    }
}
