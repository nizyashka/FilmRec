final class MyRequestsViewModel {
    let requestsStore = RequestsStore.shared
    
    var requests: [Request] {
        let requestsCoreData = fetchRequestsFromCoreData()
        let requests = toRequest(from: requestsCoreData)
        
        return requests
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
    
    private func toRequest(from requestsCoreData: [RequestCoreData]) -> [Request] {
        var requests: [Request] = []
        
        for requestCoreData in requestsCoreData {
            guard let id = requestCoreData.id,
                  let name = requestCoreData.name,
                  let genre = requestCoreData.genre,
                  let country = requestCoreData.country,
                  let director = requestCoreData.director,
                  let decade = requestCoreData.decade else {
                assertionFailure("[RequestsViewModel] - requestCoreDataToRequest: Error getting properties from RequestCoreData.")
                return requests
            }
            
            let request = Request(
                id: id,
                name: name,
                genre: genre,
                country: country,
                director: director,
                decade: decade)
            
            requests.append(request)
        }
        
        return requests
    }
}
