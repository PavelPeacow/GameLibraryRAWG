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
        
        home.tabBarItem.title = "Home"
        seacrh.tabBarItem.title = "Seacrh"
        
        home.tabBarItem.image = UIImage(systemName: "house.fill")
        seacrh.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        tabBarController?.tabBar.tintColor = .systemBackground
        
        setViewControllers([home, seacrh], animated: true)
        
        
    }


}

