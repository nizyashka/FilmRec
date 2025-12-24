import Foundation

enum NetworkingErrors: Error {
    case noResponse
    case noData
}

enum DecodingErrors: Error {
    case decodingError
}

enum CoreDataErrors: Error {
    case errorSaving
    case errorDeleting
}
