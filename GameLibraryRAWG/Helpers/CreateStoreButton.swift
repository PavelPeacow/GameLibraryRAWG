//
//  CreateStoreButton.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 02.09.2022.
//


import UIKit

class StoreButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(with image: Stores) {
        super.init(frame: .zero)
        
        setImage(UIImage(named: image.rawValue), for: .normal)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
