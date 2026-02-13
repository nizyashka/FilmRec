import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FilmsAndRequests")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as? NSError {
                assertionFailure("[CoreDataStack] - persistentContainer: Unresolved error \(error), \(error.userInfo).")
            }
        })
        
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() { }
    
    func saveContext() throws {
        let context = viewContext
        if context.hasChanges {
            try context.save()
        }
    }
}
