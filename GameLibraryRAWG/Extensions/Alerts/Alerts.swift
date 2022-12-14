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
    
    func showIncorrectPasswordSignInAlert() {
       let ac = UIAlertController(title: "Incorrect password", message: nil, preferredStyle: .alert)
       ac.addAction(UIAlertAction(title: "OK", style: .default))
                    
       present(ac, animated: true)
   }
    
    func showAccountDisableSignInAlert() {
        let ac = UIAlertController(title: "Account temporarily disable",
                                   message: "Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.", preferredStyle: .alert)
       ac.addAction(UIAlertAction(title: "OK", style: .default))
                    
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
    
    func showEmailInUseAlert() {
        let ac = UIAlertController(title: "Email is already in user",
                                   message: "try another email", preferredStyle: .alert)
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
    
    func showNicknameInvalidValidationAlert() {
        let ac = UIAlertController(title: "Nickname must meet the following requirements",
                                   message: "Length must be at least 1 char and maximum 13\nCan contains only _ special symbol\n", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showEmailInvalidValidationAlert() {
        let ac = UIAlertController(title: "Email must meet the following requirements",
                                   message: "You need provide a valid email", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showPasswordInvalidValidationAlert() {
        let ac = UIAlertController(title: "Password must meet the following requirements",
                                   message: "Length must be at least 7\nContains at least 1 number\nContains at least 1 char", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showPasswordAreNotTheSameValidationAlert() {
        let ac = UIAlertController(title: "Password must meet the following requirements",
                                   message: "Passwords must match", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
        
}
