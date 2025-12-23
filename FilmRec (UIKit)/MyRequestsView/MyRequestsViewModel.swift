import UIKit

final class MyRequestsViewModel {
    let requestsStore = RequestsStore.shared
    
    var requests: [Request] {
        toRequest(from: requestsCoreData)
    }
    
    var requestsCoreData: [RequestCoreData] {
        fetchRequestsFromCoreData()
    }
    
    private func fetchRequestsFromCoreData() -> [RequestCoreData] {
        guard let requestsCoreData = requestsStore.fetchedRequestsResultController.fetchedObjects else {
            assertionFailure("[RequestsModel] - fetchRequestsFromCoreData: Error getting fetched objects from Requests Store.")
            return []
        }
        
        return requestsCoreData
    }
    
    
    //TODO: - Вынести в request store
    private func toRequest(from requestsCoreData: [RequestCoreData]) -> [Request] {
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
                assertionFailure("[RequestsViewModel] - requestCoreDataToRequest: Error getting properties from RequestCoreData.")
                return requests
            }
            
            let request = Request(
                id: id,
                name: name,
                genre: genre,
                country: country,
                director: director,
                decade: decade,
                color: dataToColor(color)?.withAlphaComponent(0.63) ?? UIColor.systemOrange.withAlphaComponent(0.63),
                dateCreated: dateCreated,
                dateExecuted: dateExecuted)
            
            requests.append(request)
        }
        
        return requests
    }
    
    private func dataToColor(_ data: Data) -> UIColor? {
        try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
}
