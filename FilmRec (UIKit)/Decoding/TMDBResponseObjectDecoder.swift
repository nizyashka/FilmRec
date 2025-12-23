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
    
    func decodeTMDBResponseForFilmByID(from data: Data) -> FilmTMDB? {
        do {
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(FilmTMDB.self, from: data)
            return decodedResponse
        } catch {
            print("[OpenAIResponseObjectDecoder] - decodeTMDBResponseForFilmByID: Error decoding a film from TMDB.")
            return nil
        }
    }
}
