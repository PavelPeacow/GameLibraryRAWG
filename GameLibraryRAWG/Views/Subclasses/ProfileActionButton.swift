//
//  ProfileButton.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 11.09.2022.
//

import UIKit

class ProfileActionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(configuration: Configuration, title: String) {
        super.init(frame: .zero)
        self.configuration = configuration
        self.setTitle(title, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
