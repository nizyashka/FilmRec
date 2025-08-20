//
//  OpenAIService.swift
//  FilmRec (Storyboard)
//
//  Created by Алексей Непряхин on 18.04.2025.
//

import Foundation

final class OpenAIService {
    static let shared = OpenAIService()
    
    private let urlSession = URLSession.shared
    private let createPrompt = PromptCreation.shared
    
    private init() { }
    
    private func makeOpenAIRequest(prompt: String) -> URLRequest? {
        let json = ["model": "gpt-3.5-turbo", "input": prompt]
        let jsonData: Data?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: json)
        } catch {
            print("[OpenAIService] - makeOpenAIRequest: Error converting dictionary to JSON data.")
            return nil
        }
        
        guard let url = URL(string: Constants.openAIResponseURL) else {
            print("[OpenAIService] - makeOpenAIRequest: Wrong URL.")
            return nil
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Constants.openAIAPIKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        return request
    }
    
    func fetchOpenAIResponse(with prompt: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let request = makeOpenAIRequest(prompt: prompt) else {
            print("[OpenAIService] - fetchOpenAIResponse: Received no request")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("[OpenAIService] - fetchOpenAIResponse: URLSession received an error: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("[OpenAIService] - fetchOpenAIResponse: Received no response code")
                completion(.failure(NetworkingErrors.noResponse))
                return
            }
            print(response.statusCode)
            
            guard let data = data else {
                print("[OpenAIService] - fetchOpenAIResponse: Received no data")
                completion(.failure(NetworkingErrors.noData))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}
