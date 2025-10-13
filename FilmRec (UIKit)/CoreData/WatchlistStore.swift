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
            NSSortDescriptor(keyPath: \WatchlistCoreData.date, ascending: false)
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
        let watchlist = WatchlistCoreData(context: context)
        
        watchlist.id = UUID()
        watchlist.date = Date()
        watchlist.film = film
        
        film.watchlist = watchlist
        
        do {
            try CoreDataStack.shared.saveContext()
            return
        } catch {
            assertionFailure("[WatchlistStore] - addToWatchlist: Failed to add film to watchlist in Core Data.")
            return
        }
    }
    
    func removeFilmFromWatchlist(watchlist: WatchlistCoreData) {
        let film = watchlist.film
        film?.watchlist = nil
        
        context.delete(watchlist)
        
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
