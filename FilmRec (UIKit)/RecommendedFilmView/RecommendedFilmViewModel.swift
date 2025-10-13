//
//  RecommendedFilmViewModel.swift
//  FilmRec (UIKit)
//
//  Created by Алексей Непряхин on 10.09.2025.
//

import Foundation

final class RecommendedFilmViewModel {
    let filmsStore = FilmsStore.shared
    let watchlistStore = WatchlistStore.shared
    
    let requestCoreData: RequestCoreData?
    let film: Film
    
    init(requestCoreData: RequestCoreData? = nil, film: Film) {
        self.requestCoreData = requestCoreData
        self.film = film
    }
    
    func addToWatchlist() {
        guard let filmCoreData = filmsStore.fetchedFilmsResultController.fetchedObjects?.first(where: { $0.id == film.id }) else {
            assertionFailure("[RecommendedFilmViewModel] - isInWatchlist: Error getting a film from Core Data.")
            return
        }
        
        watchlistStore.addFilmToWatchlist(film: filmCoreData)
    }
    
    func removeFromWatchlist() {
        guard let filmCoreData = filmsStore.fetchedFilmsResultController.fetchedObjects?.first(where: { $0.id == film.id }),
              let watchlistCoreData = filmCoreData.watchlist else {
            assertionFailure("[RecommendedFilmViewModel] - isInWatchlist: Error getting a film from Core Data.")
            return
        }
        
        watchlistStore.removeFilmFromWatchlist(watchlist: watchlistCoreData)
    }
    
//    func toggleWatchlist() {
//        guard let filmCoreData = filmsStore.fetchedFilmsResultController.fetchedObjects?.first(where: { $0.id == film.id }) else {
//            assertionFailure("[RecommendedFilmViewModel] - isInWatchlist: Error getting a film from Core Data.")
//            return
//        }
//        
//        filmCoreData.isInWatchlist.toggle()
//        
//        do {
//            try CoreDataStack.shared.saveContext()
//            return
//        } catch {
//            assertionFailure("[RecommendedFilmViewModel] - toggleWatchlist: Failed to save watchlist toggle to Core Data.")
//            return
//        }
//    }
    
    func isInWatchlist() -> Bool {
        guard let filmCoreData = filmsStore.fetchedFilmsResultController.fetchedObjects?.first(where: { $0.id == film.id }) else {
            assertionFailure("[RecommendedFilmViewModel] - isInWatchlist: Error getting a film from Core Data.")
            return false
        }
        
        guard filmCoreData.watchlist != nil else {
            return false
        }
        
        return true
    }
}
