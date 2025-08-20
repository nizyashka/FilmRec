//
//  ErrorEnums.swift
//  FilmRec (Storyboard)
//
//  Created by Алексей Непряхин on 17.05.2025.
//

import Foundation

enum NetworkingErrors: Error {
    case noResponse
    case noData
}

enum DecodingErrors: Error {
    case decodingError
}
