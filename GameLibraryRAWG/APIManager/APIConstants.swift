//
//  APIConstants.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 25.08.2022.
//

import Foundation

struct APIConstants {
    static let API_KEY = "959cc7bd09e143d5ae5b5bc89fd5eb83"
    static let BASE_URL = "https://api.rawg.io/api"
    
    static let METACRITIC_URL = "\(BASE_URL)/games?key=\(API_KEY)&dates=2000-01-01,2022-12-31&ordering=-metacritic&page_size=50"
    static let POPULAR_URL = "\(BASE_URL)/games?key=\(API_KEY)&dates=2022-01-01,2022-12-31&ordering=-added"
    static let UPCOMING_URL = "\(BASE_URL)/games?key=\(API_KEY)&dates=2022-08-28,2025-12-31&ordering=-added&page_size=50"
    static let DISCOVER_URL = "\(APIConstants.BASE_URL)/games?key=\(APIConstants.API_KEY)&ordering=-added&page_size=40"
}
