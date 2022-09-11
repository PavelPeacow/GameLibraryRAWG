//
//  ViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 25.08.2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let home = UINavigationController(rootViewController: HomeViewController())
        let seacrh = UINavigationController(rootViewController: SearchViewController())
        
        var profile = UINavigationController(rootViewController: ProfileAuthorizationViewController())
        
        if let _ = FirebaseManager.shared.auth.currentUser {
            profile = UINavigationController(rootViewController: ProfileMainViewController())
        }
        
        
        home.tabBarItem.title = "Home"
        seacrh.tabBarItem.title = "Seacrh"
        profile.tabBarItem.title = "Profile"
        
        home.tabBarItem.image = UIImage(systemName: "house.fill")
        seacrh.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        profile.tabBarItem.image = UIImage(systemName: "person")
        
        tabBarController?.tabBar.tintColor = .systemBackground
        
        setViewControllers([home, seacrh, profile], animated: true)
        
        
    }

}

