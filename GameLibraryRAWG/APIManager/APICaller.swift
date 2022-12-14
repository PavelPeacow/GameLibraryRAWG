//
//  APICaller.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 25.08.2022.
//

import Foundation

enum APIError: Error {
    case failedToGetData
    case failedToDecodeData
}

final class APICaller {
    static let shared = APICaller()
    
    func fetchGames<T: Codable>(url: String, expecting: T.Type, randomPageNumber: Int?, onCompletion: @escaping (Result<T, APIError>) -> Void) {
        var url = url
        if let randomPageNumber = randomPageNumber {
            url = url + "&page=\(randomPageNumber)"
        }
            
        guard let url = URL(string: url) else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else {
                onCompletion(.failure(.failedToGetData))
                return
            }
            
            guard let results = try? JSONDecoder().decode(expecting.self, from: data) else {
                onCompletion(.failure(.failedToGetData))
                return
            }
            
            onCompletion(.success(results))
        }
        task.resume()
    }
    
    func fetchGamesWithPage<T: Codable>(url: String, expecting: T.Type, pageNumber: Int, onCompletion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: "\(APIConstants.BASE_URL)/games?key=\(APIConstants.API_KEY)&ordering=-added&page_size=20&page=\(pageNumber)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else {
                onCompletion(.failure(.failedToGetData))
                return
            }
            
            guard let results = try? JSONDecoder().decode(expecting.self, from: data) else {
                onCompletion(.failure(.failedToGetData))
                return
            }
            
            onCompletion(.success(results))
        }
        task.resume()
    }
    
    
    func searchGames(with query: String, onCompletion: @escaping (Result<[Game], APIError>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(APIConstants.BASE_URL)/games?key=\(APIConstants.API_KEY)&page_size=20&search=\(query)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                onCompletion(.failure(.failedToGetData))
                return
            }

            guard let results = try? JSONDecoder().decode(GamesResponse.self, from: data) else {
                onCompletion(.failure(.failedToGetData))
                return
            }
            
            onCompletion(.success(results.results))
        }
        task.resume()
    }
    
    
    func fetchMainGameDetails(with gameId: String, onCompletion: @escaping (Result<GameDetail, APIError>) -> Void) {
        
        guard let url = URL(string: "\(APIConstants.BASE_URL)/games/\(gameId)?key=\(APIConstants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                onCompletion(.failure(.failedToGetData))
                return
            }

            guard let results = try? JSONDecoder().decode(GameDetail.self, from: data) else {
                onCompletion(.failure(.failedToGetData))
                return
            }
            
            onCompletion(.success(results))
        }
        task.resume()
    }
    
    
    func fetchSpecificGameDetails<T: Codable>(with gameId: String, endpoint: APIEndpoints, expecting: T.Type, onCompletion: @escaping (Result<T, APIError>) -> Void) {
        
        guard let url = URL(string: "\(APIConstants.BASE_URL)/games/\(gameId)/\(endpoint)?key=\(APIConstants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                onCompletion(.failure(.failedToGetData))
                return
            }

            guard let results = try? JSONDecoder().decode(T.self, from: data) else {
                onCompletion(.failure(.failedToGetData))
                return
            }
            
            onCompletion(.success(results))
        }
        task.resume()
    }

}
