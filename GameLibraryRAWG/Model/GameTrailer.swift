//
//  GameTrailerModel.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 06.09.2022.
//

import Foundation

struct GameTrailerResponse: Codable {
    let results: [GameTrailer]
}

struct GameTrailer: Codable {
    let name: String
    let preview: String
    let data: GameTrailerData
}

struct GameTrailerData: Codable {
    let max: String
}
