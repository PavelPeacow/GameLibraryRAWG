//
//  SliderCollectionViewCell.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 31.08.2022.
//

import UIKit
import SDWebImage

class SliderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SliderCollectionViewCell"
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        image.frame = contentView.bounds
    }
    
    public func configure(with model: String) {
        guard let url = URL(string: model) else { return }
        print(model)
        image.sd_imageIndicator = SDWebImageActivityIndicator.medium
        image.sd_setImage(with: url)
    }
}
