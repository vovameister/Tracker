//
//  TrackerStore.swift
//  Tracker
//
//  Created by Владимир Клевцов on 23.11.23..
//
import CoreData
import UIKit
struct TrackerStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}

protocol TrackerCoreDataStoreDelegate: AnyObject {
    func didUpdate(_ update: TrackerStoreUpdate)
}

class TrackerCoreDataStore: NSObject, NSFetchedResultsControllerDelegate {
    weak var delegate: TrackerCoreDataStoreDelegate?
    static let shared = TrackerCoreDataStore()
    
    var filterPredicates = [NSPredicate]()
    var textPredicate: NSPredicate?
    var datePredecate: NSPredicate?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerStoreUpdate.Move>?
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(managedObjectContext: context)
    }
    init(managedObjectContext: NSManagedObjectContext) {
        self.context = managedObjectContext
        super.init()
        setupFetchedResultsController()
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "action", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        movedIndexes = Set<TrackerStoreUpdate.Move>()    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(TrackerStoreUpdate(
            insertedIndexes: insertedIndexes!,
            deletedIndexes: deletedIndexes!,
            updatedIndexes: updatedIndexes!,
            movedIndexes: movedIndexes!
        )
        )
        insertedIndexes = nil
        deletedIndexes = nil
        updatedIndexes = nil
        movedIndexes = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndexes?.insert(indexPath.item)
        case .delete:
            guard let indexPath = indexPath else { fatalError() }
            deletedIndexes?.insert(indexPath.item)
        case .update:
            guard let indexPath = indexPath else { fatalError() }
            updatedIndexes?.insert(indexPath.item)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { fatalError() }
            movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
        @unknown default:
            fatalError()
        }
    }
}
extension TrackerCoreDataStore {
    func trackerCategory(at indexPath: IndexPath) -> String {
        guard let frc = fetchedResultsController, frc.sections?.count ?? 0 > 0 else {
            return ""
        }
        guard indexPath.section < frc.sections!.count else {
            return ""
        }
        guard indexPath.row < frc.sections![indexPath.section].numberOfObjects else {
            return ""
        }
        let tracker = frc.object(at: indexPath)
        guard let category = tracker.categorys else {
            return ""
        }
        return category.title ?? ""
    }
    
    
    func numberOfSections() -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tracker(at indexPath: IndexPath) -> TrackerCoreData? {
        return fetchedResultsController?.object(at: indexPath)
    }
    func updateFilterPredicate(text: String?, weekday: Int?) {
        var filterPredicates = [NSPredicate]()
           if let text = text, !text.isEmpty {
               textPredicate = NSPredicate(format: "action CONTAINS[cd] %@", text)
               filterPredicates.append(textPredicate!)
           }
//        if let weekday = weekday {
//            let dayOfWeekName = DateFormatter().weekdaySymbols[(weekday - 1 + 7) % 7].lowercased()
//            datePredecate = NSPredicate(format: "ANY schedule.day.name CONTAINS[cd] %@ AND ANY schedule.isSelected == true", dayOfWeekName)
//            if let datePredecate = datePredecate {
//                filterPredicates.append(datePredecate)
//            }
//        }
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: filterPredicates)

            fetchedResultsController?.fetchRequest.predicate = compoundPredicate

            do {
                try fetchedResultsController?.performFetch()
                    
                    if let fetchedObjects = fetchedResultsController?.fetchedObjects {
                        for object in fetchedObjects {
                            if let managedObject = object as? NSManagedObject {
                                // Access and print data from the managed object
                                print("Fetched Object: \(managedObject)")
                                
                            }
                        }
                    }
            } catch {
                print("Error performing fetch after updating predicate: \(error)")
            }
    }
}

