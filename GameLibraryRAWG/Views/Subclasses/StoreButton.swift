//
//  StoreButton.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 02.09.2022.
//


import UIKit

class StoreButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(with image: Stores, action: UIAction) {
        super.init(frame: .zero)
        
        setImage(UIImage(named: image.rawValue), for: .normal)
        addAction(action, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
