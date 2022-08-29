//
//  GameDetailModel.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 29.08.2022.
//

import Foundation

struct GameDetail: Codable {
    let name: String?
    let background_image: String?
    let desctiption: String?
    let metacritic: Int?
}
