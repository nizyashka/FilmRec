import CoreData

protocol RequestsStoreDelegate: AnyObject {
    func updateTableOrCollectionView()
}

final class RequestsStore: NSObject {
    let context = CoreDataStack.shared.viewContext
    
    static let shared = RequestsStore()
    weak var requestsStoreDelegate: RequestsStoreDelegate?
    
    override private init() { }
    
    lazy var fetchedRequestsResultController: NSFetchedResultsController<RequestCoreData> = {
        let fetchRequest = RequestCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \RequestCoreData.name, ascending: true)
        ]
        
        let fetchedRequestsResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedRequestsResultController.delegate = self
        try? fetchedRequestsResultController.performFetch()
        
        return fetchedRequestsResultController
    }()
    
    func addRequestToCoreData(name: String, genre: String, country: String, director: String, decade: String) {
        let request = RequestCoreData(context: context)
        request.id = UUID()
        request.name = name
        request.genre = genre
        request.country = country
        request.director = director
        request.decade = decade
        
        do {
            try CoreDataStack.shared.saveContext()
        } catch {
            assertionFailure("[RequestsStore] - addRequestToCoreData: Failed to add request to Core Data.")
        }
    }
    
    func removeRequestFromCoreData(_ requestCoreData: RequestCoreData) {
        guard let films = requestCoreData.films as? Set<FilmCoreData> else {
            assertionFailure("[RequestsStore] - removeRequestFromCoreData: Error getting films for request.")
            return
        }
        
        if !films.isEmpty {
            for film in films {
                film.removeFromRequests(requestCoreData)
            }
        }
        
        context.delete(requestCoreData)
        
        do {
            try CoreDataStack.shared.saveContext()
            return
        } catch {
            assertionFailure("[RequestsStore] - removeRequestFromCoreData: Failed to remove request from Core Data.")
            return
        }
    }
}

extension RequestsStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        requestsStoreDelegate?.updateTableOrCollectionView()
    }
}
