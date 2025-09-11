//
//  WatchlistViewModel.swift
//  FilmRec (UIKit)
//
//  Created by Алексей Непряхин on 10.09.2025.
//

import Foundation

final class WatchlistViewModel {
    let filmsStore = FilmsStore.shared
    let tmdbService = TMDBService.shared
    let tmdbResponseObjectDecoder = TMDBResponseObjectDecoder.shared
    
    private(set) var filmsInWatchlist: [Film] = []
    
    var controllerDidChangeContent: (() -> Void)?
    
    init() {
        filmsStore.filmsStoreDelegate = self
        loadFilmsFromWatchlist()
    }
    
    func loadFilmsFromWatchlist() {
        var filmsInWatchlist: [Film] = []
        let group = DispatchGroup()
        
        guard let filmsCoreData = self.filmsStore.fetchedFilmsResultController.fetchedObjects else {
            assertionFailure("[WatchlistViewModel] - loadFilmsFromWatchlist: Error fetching films from Core Data.")
            return
        }
        
        for filmCoreData in filmsCoreData {
            group.enter()
            self.tmdbService.fetchFilmByID(filmCoreData.id) { result in
                switch result {
                case .success(let data):
                    guard let responseObject = self.tmdbResponseObjectDecoder.decodeTMDBResponseForFilmByID(from: data) else {
                        assertionFailure("[WatchlistViewModel] - loadFilmsFromWatchlist: Error decoding data.")
                        return
                    }
                    
                    filmsInWatchlist.append(responseObject)
                case .failure(let error):
                    assertionFailure("[WatchlistViewModel] - loadFilmsFromWatchlist: Error fetching a film from TMDB. Error - \(error.localizedDescription)")
                    return
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.filmsInWatchlist = filmsInWatchlist
        }
    }
}

extension WatchlistViewModel: FilmsStoreDelegate {
    func updateCollectionView() {
        loadFilmsFromWatchlist()
        controllerDidChangeContent?()
    }
}
