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
    
    func fetchGames(onCompletion: @escaping (Result<[Game], Error>) -> Void) {
        guard let url = URL(string: "\(APIConstants.BASE_URL)/games?key=\(APIConstants.API_KEY)&page_size=20") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else {
                print("data was nil")
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
    
    
    func fetchPopularGames(onCompletion: @escaping (Result<[Game], Error>) -> Void) {
        guard let url = URL(string: "\(APIConstants.BASE_URL)/games?key=\(APIConstants.API_KEY)&dates=2022-01-01,2022-12-31&ordering=-added") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else {
                print("data was nil")
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
    
    
    func fetchMustPlayGames(onCompletion: @escaping (Result<[Game], Error>) -> Void) {
        guard let url = URL(string: "\(APIConstants.BASE_URL)/games?key=\(APIConstants.API_KEY)&dates=2000-01-01,2022-12-31&ordering=-metacritic&page_size=50") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else {
                print("data was nil")
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
    
    
    func fetchUpcomingGames(onCompletion: @escaping (Result<[Game], Error>) -> Void) {
        guard let url = URL(string: "\(APIConstants.BASE_URL)/games?key=\(APIConstants.API_KEY)&dates=2022-08-28,2025-12-31&ordering=-added&page_size=50") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else {
                print("data was nil")
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

}
