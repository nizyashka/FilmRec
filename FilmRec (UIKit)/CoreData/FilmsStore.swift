import CoreData

protocol FilmsStoreDelegate: AnyObject {
    func updateCollectionView()
}

final class FilmsStore: NSObject {
    private var context = CoreDataStack.shared.viewContext
    
    static let shared = FilmsStore()
    weak var filmsStoreDelegate: FilmsStoreDelegate?
    
    lazy var fetchedFilmsResultController: NSFetchedResultsController<FilmCoreData> = {
        let fetchRequest = FilmCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \FilmCoreData.originalTitle, ascending: true)
        ]
        
        let fetchedFilmsResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedFilmsResultController.delegate = self
        try? fetchedFilmsResultController.performFetch()
        
        return fetchedFilmsResultController
    }()
    
    private override init() { }
    
    func addFilmToCoreData(filmTMDB: FilmTMDB, requestCoreData: RequestCoreData?) -> FilmCoreData? {
        guard let requestCoreData else {
            assertionFailure("[FilmsStore] - addFilmToCoreData: RequestCoreData is nil.")
            return nil
        }
        
        if let existingFilm = fetchedFilmsResultController.fetchedObjects?.first(where: { $0.id == filmTMDB.id }) {
            requestCoreData.dateExecuted = Date()
            requestCoreData.addToFilms(existingFilm)
            existingFilm.addToRequests(requestCoreData)
            
            do {
                try CoreDataStack.shared.saveContext()
                return existingFilm
            } catch {
                assertionFailure("[FilmsStore] - addFilmToCoreData: Failed to save context.")
                return nil
            }
        } else {
            let filmCoreData = FilmCoreData(context: context)
            
            filmCoreData.id = filmTMDB.id
            filmCoreData.originalTitle = filmTMDB.originalTitle
            filmCoreData.overview = filmTMDB.overview
            filmCoreData.posterPath = filmTMDB.posterPath
            filmCoreData.voteAverage = filmTMDB.voteAverage ?? 0.0
            filmCoreData.dateRecommended = Date()
            
            requestCoreData.dateExecuted = Date()
            filmCoreData.addToRequests(requestCoreData)
            requestCoreData.addToFilms(filmCoreData)
            
            do {
                try CoreDataStack.shared.saveContext()
                return filmCoreData
            } catch {
                assertionFailure("[FilmsStore] - addFilmToCoreData: Failed to add film to Core Data.")
                return nil
            }
        }
    }
    
    func removeFilmFromCoreData(by id: Int32) {
        guard let filmCoreData = fetchedFilmsResultController.fetchedObjects?.first(where: { $0.id == id }) else {
            assertionFailure("[FilmsStore] - removeFilmFromCoreData: Failed to find a film with this ID in Core Data.")
            return
        }
        
        context.delete(filmCoreData)
        
        do {
            try CoreDataStack.shared.saveContext()
        } catch {
            assertionFailure("[FilmsStore] - removeFilmFromCoreData: Failed to remove film from Core Data.")
        }
    }
    
    func toFilm(from filmCoreData: FilmCoreData) -> Film? {
        guard let originalTitle = filmCoreData.originalTitle,
              let dateRecommended = filmCoreData.dateRecommended else {
            assertionFailure("[FilmsStore] - toFilm: Error getting film properties.")
            return nil
        }
        
        let film = Film(id: filmCoreData.id,
                        originalTitle: originalTitle,
                        overview: filmCoreData.overview ?? "",
                        posterPath: filmCoreData.posterPath ?? "",
                        voteAverage: filmCoreData.voteAverage,
                        dateRecommended: dateRecommended)
        
        return film
    }
}

extension FilmsStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        filmsStoreDelegate?.updateCollectionView()
    }
}
