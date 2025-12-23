import Foundation

final class WatchlistViewModel {
    let watchlistStore = WatchlistStore.shared
    let filmsStore = FilmsStore.shared
    
    private(set) var filmsInWatchlist: [Film] = []
    
    var controllerDidChangeContent: (() -> Void)?
    
    init() {
        watchlistStore.watchlistStoreDelegate = self
        loadFilmsFromWatchlist()
    }
    
    func loadFilmsFromWatchlist() {
        var filmsInWatchlist: [Film] = []
        
        guard let filmsInWatchlistCoreData = watchlistStore.fetchedWatchlistResultController.fetchedObjects else {
            assertionFailure("[WatchlistViewModel] - loadFilmsFromWatchlist: Error fetching films in watchlist from Core Data.")
            return
        }
        
        for filmInWatchlistCoreData in filmsInWatchlistCoreData.sorted(by: { $0.dateWatchlisted ?? Date() > $1.dateWatchlisted ?? Date() }) {
            guard let filmCoreData = filmInWatchlistCoreData.film else {
                assertionFailure("[WatchlistViewModel] - loadFilmsFromWatchlist: Error fetching a film from WatchlistCoreData.")
                return
            }
            
            guard let film = filmsStore.toFilm(from: filmCoreData) else {
                assertionFailure("[WatchlistViewModel] - loadFilmsFromWatchlist: Error converting a film.")
                return
            }
            
            filmsInWatchlist.append(film)
        }
        
        self.filmsInWatchlist = filmsInWatchlist
    }
}

extension WatchlistViewModel: WatchlistStoreDelegate {
    func updateCollectionView() {
        loadFilmsFromWatchlist()
        controllerDidChangeContent?()
    }
}
