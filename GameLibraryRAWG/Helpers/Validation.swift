//
//  Validation.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 13.10.2022.
//

import Foundation

func validateUsername(with enteredUsername: String) -> Bool {
    let usernameFormat = "^[a-zA-Z0-9_-]{1,13}$"
    let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameFormat)
    return usernamePredicate.evaluate(with: enteredUsername)
}

func validateEmail(with enteredEmail: String) -> Bool {

    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: enteredEmail)

}

func validatePassword(with enteredPassword: String) -> Bool {
    let passwordFormat = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{7,}$"
    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordFormat)
    return passwordPredicate.evaluate(with: enteredPassword)
}
