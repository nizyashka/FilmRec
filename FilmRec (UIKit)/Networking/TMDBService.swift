//
//  TMDBService.swift
//  FilmRec (Storyboard)
//
//  Created by Алексей Непряхин on 17.05.2025.
//

import Foundation

final class TMDBService {
    static let shared = TMDBService()
    
    private let urlSession = URLSession.shared
    
    private init() { }
    
    private func makeTMDBRequest(for film: String, shotIn year: String) -> URLRequest? {
        guard let url = URL(string: Constants.tmdbSearchURL) else {
            print("[TMDBService] - makeTMDBRequest: Wrong URL.")
            return nil
        }
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            print("[TMDBService] - makeTMDBRequest: Unable to create URLComponents.")
            return nil
        }
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "query", value: film),
            URLQueryItem(name: "primary_release_year", value: year),
        ]
        
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url!)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.tmdbAPIAccessToken)"
        ]
        
        return request
    }
    
    func fetchTMDBResponse(for film: String, shotIn year: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let request = makeTMDBRequest(for: film, shotIn: year) else {
            print("[TMDBService] - fetchTMDBResponse: Was unable to get request.")
            return
        }
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error {
                print("[TMDBService] - fetchTMDBResponse: URLSession received an error: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("[TMDBService] - fetchTMDBResponse: Received no response code")
                completion(.failure(NetworkingErrors.noResponse))
                return
            }
            print(response.statusCode)
            
            guard let data = data else {
                print("[TMDBService] - fetchTMDBResponse: Received no data")
                completion(.failure(NetworkingErrors.noData))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}
