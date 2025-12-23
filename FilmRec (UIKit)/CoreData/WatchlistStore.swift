import CoreData

protocol WatchlistStoreDelegate: AnyObject {
    func updateCollectionView()
}

final class WatchlistStore: NSObject {
    private var context = CoreDataStack.shared.viewContext
    
    static let shared = WatchlistStore()
    weak var watchlistStoreDelegate: WatchlistStoreDelegate?
    
    lazy var fetchedWatchlistResultController: NSFetchedResultsController<WatchlistCoreData> = {
        let fetchRequest = WatchlistCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \WatchlistCoreData.dateWatchlisted, ascending: false)
        ]
        
        let fetchedWatchlistResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedWatchlistResultController.delegate = self
        try? fetchedWatchlistResultController.performFetch()
        
        return fetchedWatchlistResultController
    }()
    
    private override init() { }
    
    func addFilmToWatchlist(film: FilmCoreData) {
        let watchlistCoreData = WatchlistCoreData(context: context)
        
        watchlistCoreData.id = UUID()
        watchlistCoreData.dateWatchlisted = Date()
        watchlistCoreData.film = film
        
        film.watchlist = watchlistCoreData
        
        do {
            try CoreDataStack.shared.saveContext()
            return
        } catch {
            assertionFailure("[WatchlistStore] - addToWatchlist: Failed to add film to watchlist in Core Data.")
            return
        }
    }
    
    func removeFilmFromWatchlist(watchlistCoreData: WatchlistCoreData) {
        let film = watchlistCoreData.film
        film?.watchlist = nil
        
        //TODO: - Проверка на привязку к запросу или списку
        
        context.delete(watchlistCoreData)
        
        do {
            try CoreDataStack.shared.saveContext()
            return
        } catch {
            assertionFailure("[WatchlistStore] - removeFilmFromWatchlist: Failed to remove film from watchlist in Core Data.")
            return
        }
    }
}

extension WatchlistStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        watchlistStoreDelegate?.updateCollectionView()
    }
}
