//
//  GameStoreModel.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 01.09.2022.
//

import Foundation

struct GameStoreResponse: Codable {
    let results: [GameStore]
}

struct GameStore: Codable {
    let url: String
}
