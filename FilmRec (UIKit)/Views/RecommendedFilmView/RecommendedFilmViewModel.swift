import Foundation

final class RecommendedFilmViewModel {
    let filmsStore = FilmsStore.shared
    let watchlistStore = WatchlistStore.shared
    
    let film: Film
    
    init(film: Film) {
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
        
        watchlistStore.removeFilmFromWatchlist(watchlistCoreData: watchlistCoreData)
    }
    
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
