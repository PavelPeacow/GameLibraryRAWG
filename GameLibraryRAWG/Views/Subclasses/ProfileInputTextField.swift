//
//  EmailTextField.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 11.09.2022.
//

import UIKit

class ProfileInputTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(placeholder: String, isSecureTextEntryEnabled: Bool) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.borderStyle = .roundedRect
        self.clearButtonMode = .whileEditing
        self.autocorrectionType = .no
        self.keyboardType = .emailAddress
        self.enablesReturnKeyAutomatically = true
        self.isSecureTextEntry = isSecureTextEntryEnabled
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
