//
//  APICaller.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 25.08.2022.
//

import Foundation

enum APIError: Error {
    case failedToGetData
}

final class APICaller {
    static let shared = APICaller()
    
    func fetch<T: Codable>(url: String, expecting: T.Type, onCompletion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            guard let results = try? JSONDecoder().decode(expecting.self, from: data) else {
                onCompletion(.failure(APIError.failedToGetData))
                return
            }
            
            onCompletion(.success(results))
        }
        task.resume()
    }
    
    
    func searchGames(with query: String, onCompletion: @escaping (Result<[Game], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(APIConstants.BASE_URL)/games?key=\(APIConstants.API_KEY)&page_size=20&search=\(query)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            guard let results = try? JSONDecoder().decode(GamesResponse.self, from: data) else {
                onCompletion(.failure(APIError.failedToGetData))
                return
            }
            
            onCompletion(.success(results.results))
        }
        task.resume()
    }
    
    
    func fetchMainGameDetails(with gameId: String, onCompletion: @escaping (Result<GameDetail, Error>) -> Void) {
        
        guard let url = URL(string: "\(APIConstants.BASE_URL)/games/\(gameId)?key=\(APIConstants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            guard let results = try? JSONDecoder().decode(GameDetail.self, from: data) else {
                onCompletion(.failure(APIError.failedToGetData))
                return
            }
            
            onCompletion(.success(results))
        }
        task.resume()
    }
    
    
    func fetchSpecificGameDetails<T: Codable>(with gameId: String, endpoint: APIEndpoints, expecting: T.Type, onCompletion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: "\(APIConstants.BASE_URL)/games/\(gameId)/\(endpoint)?key=\(APIConstants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            guard let results = try? JSONDecoder().decode(T.self, from: data) else {
                onCompletion(.failure(APIError.failedToGetData))
                return
            }
            
            onCompletion(.success(results))
        }
        task.resume()
    }

}
