import UIKit

final class MyRequestsViewModel {
    let requestsStore = RequestsStore.shared
    
    var requests: [Request] {
        let requests = requestsStore.toRequest(from: requestsCoreData)
        return sortRequests(requests)
    }
    
    var requestsCoreData: [RequestCoreData] {
        let requestCoreData = fetchRequestsFromCoreData()
        return sortRequests(requestCoreData)
    }
    
    var controllerDidChangeContent: (() -> Void)?
    
    init() {
        requestsStore.requestsStoreDelegate = self
    }
    
    private func fetchRequestsFromCoreData() -> [RequestCoreData] {
        guard let requestsCoreData = requestsStore.fetchedRequestsResultController.fetchedObjects else {
            assertionFailure("[RequestsModel] - fetchRequestsFromCoreData: Error getting fetched objects from Requests Store.")
            return []
        }
        
        return requestsCoreData
    }
    
    var selectedSortingOption: RequestsSortingOptions {
        get {
            guard let rawValue = UserDefaults.standard.string(forKey: "requestsSortingOption"),
                  let option = RequestsSortingOptions(rawValue: rawValue) else {
                return .dateExecuted
            }
            return option
        }
        
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "requestsSortingOption")
        }
    }
    
    //TODO: - Вынести в request store
    
    
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

extension MyRequestsViewModel: RequestsStoreDelegate {
    func updateTableOrCollectionView() {
        controllerDidChangeContent?()
    }
}
