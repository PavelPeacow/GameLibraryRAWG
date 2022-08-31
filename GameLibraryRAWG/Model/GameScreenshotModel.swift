//
//  GameScreenshotModel.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 31.08.2022.
//

import Foundation

struct GameScreenshotResponse: Codable {
    let results: [GameScreenshot]
}

struct GameScreenshot: Codable {
    let image: String
}
