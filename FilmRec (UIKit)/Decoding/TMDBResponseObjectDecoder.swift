//
//  TMDBResponseObjectDecoder.swift
//  FilmRec (Storyboard)
//
//  Created by Алексей Непряхин on 17.05.2025.
//

import Foundation

final class TMDBResponseObjectDecoder {
    static let shared = TMDBResponseObjectDecoder()
    
    private init() { }
    
    func decodeTMDBResponse(from data: Data) -> TMDBResponseObject? {
        do {
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(TMDBResponseObject.self, from: data)
            return decodedResponse
        } catch {
            print("[OpenAIResponseObjectDecoder] - decodeOpenAIResponse: Error decoding Open AI response object.")
            return nil
        }
    }
    
    func decodeTMDBResponseForFilmByID(from data: Data) -> Film? {
        do {
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(Film.self, from: data)
            return decodedResponse
        } catch {
            print("[OpenAIResponseObjectDecoder] - decodeTMDBResponseForFilmByID: Error decoding a film from TMDB.")
            return nil
        }
    }
}
