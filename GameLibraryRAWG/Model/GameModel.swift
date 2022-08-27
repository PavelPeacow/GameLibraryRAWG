//
//  GameModel.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 25.08.2022.
//

import Foundation

struct GamesResponse: Codable {
    let count: Int
    let results: [Game]
}


struct Game: Codable {
    let name: String
    let background_image: String
    let ratings: [Rating]
}

struct Rating: Codable {
    let id: Int
    let title: String
    let count: Int
    let percent: Double
}
