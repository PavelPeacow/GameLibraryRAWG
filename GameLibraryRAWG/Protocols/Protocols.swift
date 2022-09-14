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
    func showCreateAccountAlert(email: String, password: String)
    func showEmptyFieldsAlert()
    func showInvalidUserAlert()
    func showRegistrationValidationAlert()
    func showChangeUserDisplayNameAlert()
}
