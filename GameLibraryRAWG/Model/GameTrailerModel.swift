//
//  GameTrailerModel.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 06.09.2022.
//

import Foundation

struct GameTrailerResponse: Codable {
    let results: [GameTrailerModel]
}

struct GameTrailerModel: Codable {
    let name: String
    let preview: String
    let data: GameTrailerData
}

struct GameTrailerData: Codable {
    let max: String
}
