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
    var context = CoreDataStack.shared.viewContext
    
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
    
    func addFilmToCoreData(id: String, request: RequestCoreData) {
        let film = FilmCoreData(context: context)
        
        film.id = id
        
        request.addToFilms(film)
        
        do {
            try CoreDataStack.shared.saveContext()
        } catch {
            assertionFailure("[FilmsStore] - addFilmToCoreData: Failed to add film to Core Data.")
        }
    }
}

extension FilmsStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        filmsStoreDelegate?.updateCollectionView()
    }
}
