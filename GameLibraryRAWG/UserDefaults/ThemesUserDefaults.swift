//
//  UserDefaultsData.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 16.09.2022.
//

import Foundation
import UIKit

enum Theme: Int {
    case light
    case dark
    case device
}

class ThemesUserDefaults {
    static let shared = ThemesUserDefaults()
    
    let userDefaultsData = UserDefaults()
    
    var theme: Theme {
        get {
            Theme(rawValue: UserDefaults.standard.integer(forKey: "selectedTheme")) ?? .device
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme")
        }
    }
}
	
