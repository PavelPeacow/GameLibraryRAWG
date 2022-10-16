//
//  ProfileGearSettingIconBtn.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 14.09.2022.
//

import UIKit

class ProfileSettingIconButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemGray
        self.layer.cornerRadius = 12
        self.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
