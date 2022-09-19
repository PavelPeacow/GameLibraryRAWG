//
//  Themes.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 16.09.2022.
//

import Foundation
import UIKit

extension UIApplication {
    
    //helper for dark/light mode
    func currentUIWindow() -> UIWindow? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first

        return window
        
    }
}
