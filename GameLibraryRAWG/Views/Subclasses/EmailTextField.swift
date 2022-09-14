//
//  EmailTextField.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 11.09.2022.
//

import UIKit

class EmailTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.borderStyle = .roundedRect
        self.clearButtonMode = .whileEditing
        self.autocorrectionType = .no
        self.keyboardType = .emailAddress
        self.enablesReturnKeyAutomatically = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
