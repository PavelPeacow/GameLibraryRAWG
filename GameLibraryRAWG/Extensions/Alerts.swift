//
//  Alerts.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 12.09.2022.
//

import Foundation
import UIKit

extension ProfileAlerts where Self: UIViewController {
    
     func showSignInAlert() {
        let ac = UIAlertController(title: "You are sign in", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "hooray!", style: .default, handler: { [weak self] _ in
            
            let vc = ProfileMainViewController()
            self?.navigationController?.setViewControllers([vc], animated: true)
            
        }))
                     
        present(ac, animated: true)
    }
    
    func showCreateAccountAlert(email: String, password: String) {
        let ac = UIAlertController(title: "Your account have been created",
                                   message: "Your email: \(email) \nYour password: \(password)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
            
            let vc = ProfileMainViewController()
            self?.navigationController?.setViewControllers([vc], animated: true)
            
        }))
        
        present(ac, animated: true)
    }
    
    func showInvalidCreateAccountAlert() {
        let ac = UIAlertController(title: "Error when creating an account",
                                   message: "Try again later", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func showChangeUserDisplayNameAlert(onCompletion: @escaping (String) -> Void) {
        let ac = UIAlertController(title: "Change nickname",
                                   message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.addAction(UIAlertAction(title: "Change", style: .default, handler: { _ in
            guard let nick = ac.textFields?.first?.text else { return }
            
            onCompletion(nick)
            
        }))
        
        present(ac, animated: true)
    }
    
    func showEmptyFieldsAlert() {
        let ac = UIAlertController(title: "All fields must be filled in", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showInvalidUserAlert() {
        let ac = UIAlertController(title: "The user does not exist", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showRegistrationValidationAlert() {
        let ac = UIAlertController(title: "You need to match the requirements",
                                   message: "You need provide a valid email,\nThe password length must be more than six", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
        
}
