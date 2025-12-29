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
        requestCoreData.color = request.color.toData()
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
    
    func toRequest(from requestsCoreData: [RequestCoreData]) -> [Request] {
        var requests: [Request] = []
        
        for requestCoreData in requestsCoreData {
            guard let id = requestCoreData.id,
                  let name = requestCoreData.name,
                  let genre = requestCoreData.genre,
                  let country = requestCoreData.country,
                  let director = requestCoreData.director,
                  let decade = requestCoreData.decade,
                  let color = requestCoreData.color,
                  let dateCreated = requestCoreData.dateCreated,
                  let dateExecuted = requestCoreData.dateExecuted else {
                assertionFailure("[RequestsStore] - requestCoreDataToRequest: Error getting properties from RequestCoreData.")
                return requests
            }
            
            let request = Request(
                id: id,
                name: name,
                genre: genre,
                country: country,
                director: director,
                decade: decade,
                color: color.toColor()?.withAlphaComponent(0.63) ?? UIColor.systemOrange.withAlphaComponent(0.63),
                dateCreated: dateCreated,
                dateExecuted: dateExecuted)
            
            requests.append(request)
        }
        
        return requests
    }
}

extension RequestsStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        requestsStoreDelegate?.updateTableOrCollectionView()
    }
}
