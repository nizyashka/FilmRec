//
//  WatchlistViewModel.swift
//  FilmRec (UIKit)
//
//  Created by Алексей Непряхин on 10.09.2025.
//

import Foundation

final class WatchlistViewModel {
    let watchlistStore = WatchlistStore.shared
    let tmdbService = TMDBService.shared
    let tmdbResponseObjectDecoder = TMDBResponseObjectDecoder.shared
    
    private(set) var filmsInWatchlist: [Film] = []
    
    var controllerDidChangeContent: (() -> Void)?
    
    init() {
        watchlistStore.watchlistStoreDelegate = self
        loadFilmsFromWatchlist()
    }
    
    func loadFilmsFromWatchlist() {
        var filmsInWatchlist: [(index: Int, film: Film)] = []
        let group = DispatchGroup()
        
//        guard let filmsCoreData = self.filmsStore.fetchedFilmsResultController.fetchedObjects?.filter( { $0.isInWatchlist } ) else {
//            assertionFailure("[WatchlistViewModel] - loadFilmsFromWatchlist: Error fetching films from Core Data.")
//            return
//        }
        
        guard let filmsInWatchlistCoreData = watchlistStore.fetchedWatchlistResultController.fetchedObjects else {
            assertionFailure("[WatchlistViewModel] - loadFilmsFromWatchlist: Error fetching films in watchlist from Core Data.")
            return
        }
        
        for (index, filmInWatchlistCoreData) in filmsInWatchlistCoreData.enumerated() {
            guard let filmCoreData = filmInWatchlistCoreData.film else {
                assertionFailure("[WatchlistViewModel] - loadFilmsFromWatchlist: Error fetching a film from WatchlistCoreData.")
                return
            }
            
            group.enter()
            self.tmdbService.fetchFilmByID(filmCoreData.id) { result in
                switch result {
                case .success(let data):
                    guard let responseObject = self.tmdbResponseObjectDecoder.decodeTMDBResponseForFilmByID(from: data) else {
                        assertionFailure("[WatchlistViewModel] - loadFilmsFromWatchlist: Error decoding data.")
                        return
                    }
                    
                    filmsInWatchlist.append((index, responseObject))
                case .failure(let error):
                    assertionFailure("[WatchlistViewModel] - loadFilmsFromWatchlist: Error fetching a film from TMDB. Error - \(error.localizedDescription)")
                    return
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            let sortedFilmsInWatchlist = filmsInWatchlist.sorted(by: { $0.index < $1.index }).map { $0.film }
            self.filmsInWatchlist = sortedFilmsInWatchlist
        }
    }
}

extension WatchlistViewModel: WatchlistStoreDelegate {
    func updateCollectionView() {
        loadFilmsFromWatchlist()
        controllerDidChangeContent?()
    }
}
