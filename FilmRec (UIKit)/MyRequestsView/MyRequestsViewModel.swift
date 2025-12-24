import UIKit

final class MyRequestsViewModel {
    let requestsStore = RequestsStore.shared
    
    var requests: [Request] {
        let requests = toRequest(from: requestsCoreData)
        return sortRequests(requests)
    }
    
    var requestsCoreData: [RequestCoreData] {
        let requestCoreData = fetchRequestsFromCoreData()
        return sortRequests(requestCoreData)
    }
    
    private func fetchRequestsFromCoreData() -> [RequestCoreData] {
        guard let requestsCoreData = requestsStore.fetchedRequestsResultController.fetchedObjects else {
            assertionFailure("[RequestsModel] - fetchRequestsFromCoreData: Error getting fetched objects from Requests Store.")
            return []
        }
        
        return requestsCoreData
    }
    
    var selectedSortingOption: RequestSortingOptions = .dateExecuted
    
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
    
    private func sortRequests(_ requests: [RequestCoreData]) -> [RequestCoreData] {
        switch selectedSortingOption {
        case .dateExecuted:
            return requests.sorted(by: { $0.dateExecuted ?? Date() > $1.dateExecuted ?? Date() })
        case .dateCreated:
            return requests.sorted(by: { $0.dateCreated ?? Date() > $1.dateCreated ?? Date() })
        case .name:
            return requests.sorted(by: { $0.name ?? "" < $1.name ?? "" })
        }
    }
    
    private func sortRequests(_ requests: [Request]) -> [Request] {
        switch selectedSortingOption {
        case .dateExecuted:
            return requests.sorted(by: { $0.dateExecuted > $1.dateExecuted })
        case .dateCreated:
            return requests.sorted(by: { $0.dateCreated > $1.dateCreated })
        case .name:
            return requests.sorted(by: { $0.name < $1.name })
        }
    }
}
