//
//  OptionsModel.swift
//  FilmRec (UIKit)
//
//  Created by Алексей Непряхин on 19.08.2025.
//

import Foundation

final class OptionsModel {
    func getSuitableOptions(optionsTabName: String) -> [String] {
        switch optionsTabName {
        case "Genre":
            return ["Any", "Comedy", "Horror", "Fantasy", "Thriller", "Action", "Drama"]
        case "Country":
            return ["Any", "USA", "Great Britain", "France", "Russia", "Italy", "Japan"]
        case "Director":
            return ["Any", "Martin Scorsese", "Quentin Tarantino", "Stanley Kubrick"]
        case "Decade":
            return ["Any", "2020s", "2010s", "2000s", "1990s", "1980s", "1970s", "1960s", "1950s", "1940s", "1930s"]
        default:
            return []
        }
    }
}
