import Foundation

final class WatchlistViewModel {
    let watchlistStore = WatchlistStore.shared
    let filmsStore = FilmsStore.shared
    
    var filmsInWatchlist: [Film] {
        return loadFilmsFromWatchlist()
    }
    
    var controllerDidChangeContent: (() -> Void)?
    
    var selectedSortingOption: WatchlistSortingOptions {
        get {
            guard let rawValue = UserDefaults.standard.string(forKey: "watchlistSortingOption"),
                  let option = WatchlistSortingOptions(rawValue: rawValue) else {
                return .dateWatchlisted
            }
            return option
        }
        
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "watchlistSortingOption")
        }
    }
    
    init() {
        watchlistStore.watchlistStoreDelegate = self
    }
    
    private func loadFilmsFromWatchlist() -> [Film] {
        var filmsInWatchlist: [Film] = []
        
        guard var filmsInWatchlistCoreData = watchlistStore.fetchedWatchlistResultController.fetchedObjects else {
            assertionFailure("[WatchlistViewModel] - loadFilmsFromWatchlist: Error fetching films in watchlist from Core Data.")
            return filmsInWatchlist
        }
        
        if selectedSortingOption == .dateWatchlisted {
            filmsInWatchlistCoreData.sort(by: { $0.dateWatchlisted ?? Date() > $1.dateWatchlisted ?? Date() })
        }
        
        for filmInWatchlistCoreData in filmsInWatchlistCoreData {
            guard let filmCoreData = filmInWatchlistCoreData.film else {
                assertionFailure("[WatchlistViewModel] - loadFilmsFromWatchlist: Error fetching a film from WatchlistCoreData.")
                return filmsInWatchlist
            }
            
            guard let film = filmsStore.toFilm(from: filmCoreData) else {
                assertionFailure("[WatchlistViewModel] - loadFilmsFromWatchlist: Error converting a film.")
                return filmsInWatchlist
            }
            
            filmsInWatchlist.append(film)
        }
        
        return sortFilms(filmsInWatchlist)
    }
    
    private func sortFilms(_ films: [Film]) -> [Film] {
        switch selectedSortingOption {
        case .dateRecommended:
            return films.sorted(by: { $0.dateRecommended > $1.dateRecommended })
        case .name:
            return films.sorted(by: { $0.originalTitle < $1.originalTitle })
        default:
            return films
        }
    }
}

extension WatchlistViewModel: WatchlistStoreDelegate {
    func updateCollectionView() {
        controllerDidChangeContent?()
    }
}
