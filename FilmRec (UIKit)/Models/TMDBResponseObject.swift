import Foundation

struct TMDBResponseObject: Codable {
    var results: [FilmTMDB]?
}

struct FilmTMDB: Codable {
    var id: Int32
    var originalTitle: String
    var overview: String?
    var posterPath: String?
    var voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case originalTitle = "title"
        case overview = "overview"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
