//
//  MyRequestsModel.swift
//  FilmRec (UIKit)
//
//  Created by Алексей Непряхин on 31.07.2025.
//

final class MyRequestsModel {
    let requestsStore = RequestsStore.shared
    
    func fetchRequestsFromCoreData() -> [RequestCoreData] {
        guard let requestsCoreData = requestsStore.fetchedRequestsResultController.fetchedObjects else {
            assertionFailure("[RequestsModel] - fetchRequestsFromCoreData: Error getting fetched objects from Requests Store.")
            return []
        }
        
        return requestsCoreData
    }
}
