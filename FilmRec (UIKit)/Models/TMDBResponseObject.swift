//
//  TMDBResponseObject.swift
//  FilmRec (Storyboard)
//
//  Created by Алексей Непряхин on 17.05.2025.
//

import Foundation

struct TMDBResponseObject: Codable {
    var results: [Film]?
}

struct Film: Codable {
    var id: Int32
    var originalTitle: String
    var overview: String?
    var posterPath: String?
    var voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case originalTitle = "original_title"
        case overview = "overview"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
