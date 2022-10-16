//
//  Protocols.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 12.09.2022.
//

import Foundation

protocol ActivityIndicator {
    func loadingIndicator()
    func removeLoadingIndicator()
}

protocol ProfileAlerts {
    func showSignInAlert()
    func showIncorrectPasswordSignInAlert()
    func showAccountDisableSignInAlert()
    func showCreateAccountAlert(email: String, password: String)
    func showEmptyFieldsAlert()
    func showInvalidUserAlert()
    func showEmailInUseAlert()
    
    func showNicknameInvalidValidationAlert()
    func showEmailInvalidValidationAlert()
    func showPasswordInvalidValidationAlert()
    func showPasswordAreNotTheSameValidationAlert()
}
