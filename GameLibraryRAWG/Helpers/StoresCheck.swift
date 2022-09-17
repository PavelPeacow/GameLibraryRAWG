//
//  StoresCheck.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 17.09.2022.
//

import Foundation


//MARK: check stores
func checkStores(with storeURL: String) -> String {
    
    let store: String
    
    switch storeURL {
        
    case _ where storeURL.contains(Stores.steam.rawValue):
        store = Stores.steam.rawValue
        
    case _ where storeURL.contains(Stores.microsoft.rawValue):
        store = Stores.microsoft.rawValue
        
    case _ where storeURL.contains(Stores.xbox.rawValue):
        store = Stores.xbox.rawValue
        
    case _ where storeURL.contains(Stores.playstation.rawValue):
        store = Stores.playstation.rawValue
        
    case _ where storeURL.contains(Stores.nintendo.rawValue):
        store = Stores.nintendo.rawValue
        
    case _ where storeURL.contains(Stores.gog.rawValue):
        store = Stores.gog.rawValue
        
    case _ where storeURL.contains(Stores.appleStore.rawValue):
        store = Stores.appleStore.rawValue
        
    case _ where storeURL.contains(Stores.googleStore.rawValue):
        store = Stores.googleStore.rawValue
        
    case _ where storeURL.contains(Stores.epicgames.rawValue):
        store = Stores.epicgames.rawValue
        
    default:
        store = "unknown store"
    }
    
    return store
}
