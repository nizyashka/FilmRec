//
//  MainViewPresenter.swift
//  FilmRec (Storyboard)
//
//  Created by Алексей Непряхин on 17.05.2025.
//

final class MyRequestsViewModel {
    private let myRequestsModel = MyRequestsModel()
    
    var requests: [Request] {
        let requestsCoreData = self.myRequestsModel.fetchRequestsFromCoreData()
        
        let requests = toRequest(from: requestsCoreData)
        
        return requests
    }
    
    private func toRequest(from requestsCoreData: [RequestCoreData]) -> [Request] {
        var requests: [Request] = []
        
        for requestCoreData in requestsCoreData {
            guard let name = requestCoreData.name,
                  let genre = requestCoreData.genre,
                  let country = requestCoreData.country,
                  let director = requestCoreData.director,
                  let decade = requestCoreData.decade else {
                assertionFailure("[RequestsViewModel] - requestCoreDataToRequest: Error getting properties from RequestCoreData.")
                return requests
            }
            
            let request = Request(
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
