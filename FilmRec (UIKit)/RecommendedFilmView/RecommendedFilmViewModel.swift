//
//  RecommendedFilmViewModel.swift
//  FilmRec (UIKit)
//
//  Created by Алексей Непряхин on 10.09.2025.
//

import Foundation

final class RecommendedFilmViewModel {
    let filmsStore = FilmsStore.shared
    
    let requestCoreData: RequestCoreData?
    let film: Film
    
    init(requestCoreData: RequestCoreData? = nil, film: Film) {
        self.requestCoreData = requestCoreData
        self.film = film
    }
    
    func addToWatchlist() {
        guard let requestCoreData else {
            assertionFailure("[RecommendedFilmViewModel] - addToWatchlist: No request to save.")
            return
        }
        
        filmsStore.addFilmToCoreData(id: film.id, request: requestCoreData)
    }
}
