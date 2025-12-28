import CoreData
import UIKit

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
            NSSortDescriptor(keyPath: \RequestCoreData.dateExecuted, ascending: true)
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
    
    func addRequestToCoreData(request: Request) {
        let requestCoreData = RequestCoreData(context: context)
        requestCoreData.id = request.id
        requestCoreData.name = request.name
        requestCoreData.genre = request.genre
        requestCoreData.country = request.country
        requestCoreData.director = request.director
        requestCoreData.decade = request.decade
        requestCoreData.color = colorToData(request.color)
        requestCoreData.dateCreated = request.dateCreated
        requestCoreData.dateExecuted = request.dateExecuted
        
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
                
                let filmRequests = film.requests as? Set<RequestCoreData>
                
                if (filmRequests == nil || filmRequests?.isEmpty == true),
                   film.watchlist == nil {
                    print(film.originalTitle)
                    context.delete(film)
                }
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
    
    private func colorToData(_ color: UIColor) -> Data? {
        try? NSKeyedArchiver.archivedData(
            withRootObject: color,
            requiringSecureCoding: false
        )
    }
}

extension RequestsStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        requestsStoreDelegate?.updateTableOrCollectionView()
    }
}
