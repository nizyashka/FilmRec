//
//  FilmsStore.swift
//  FilmRec (UIKit)
//
//  Created by Алексей Непряхин on 31.07.2025.
//

import CoreData

protocol FilmsStoreDelegate: AnyObject {
    func updateCollectionView()
}

final class FilmsStore: NSObject {
    private var context = CoreDataStack.shared.viewContext
    
    static let shared = FilmsStore()
    weak var filmsStoreDelegate: FilmsStoreDelegate?
    
    lazy var fetchedFilmsResultController: NSFetchedResultsController<FilmCoreData> = {
        let fetchRequest = FilmCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \FilmCoreData.id, ascending: true)
        ]
        
        let fetchedFilmsResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedFilmsResultController.delegate = self
        try? fetchedFilmsResultController.performFetch()
        
        return fetchedFilmsResultController
    }()
    
    private override init() { }
    
    func addFilmToCoreData(id: Int32, request: RequestCoreData) {
        if let existingFilm = fetchedFilmsResultController.fetchedObjects?.first(where: { $0.id == id }) {
            request.addToFilms(existingFilm)
            existingFilm.addToRequests(request)
        } else {
            let film = FilmCoreData(context: context)
            
            film.id = id
            
            request.addToFilms(film)
            
            do {
                try CoreDataStack.shared.saveContext()
                return
            } catch {
                assertionFailure("[FilmsStore] - addFilmToCoreData: Failed to add film to Core Data.")
                return
            }
        }
    }
    
    func removeFilmFromCoreData(by id: Int32) {
        guard let filmCoreData = fetchedFilmsResultController.fetchedObjects?.first(where: { $0.id == id }) else {
            assertionFailure("[FilmsStore] - removeFilmFromCoreData: Failed to find a film with this ID in Core Data.")
            return
        }
        
        context.delete(filmCoreData)
        
        do {
            try CoreDataStack.shared.saveContext()
            return
        } catch {
            assertionFailure("[FilmsStore] - removeFilmFromCoreData: Failed to remove film from Core Data.")
            return
        }
    }
}

extension FilmsStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        filmsStoreDelegate?.updateCollectionView()
    }
}
