import Foundation

enum NetworkingErrors: Error {
    case noResponse
    case noData
}

enum DecodingErrors: Error {
    case decodingError
}
