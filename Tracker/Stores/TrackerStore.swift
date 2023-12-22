//
//  TrackerStore.swift
//  Tracker
//
//  Created by Владимир Клевцов on 23.11.23..
//
import CoreData
import UIKit
enum TrackerStoreError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidTitle
    case decodingErrorInvalidColor
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidSchedule
    case decodingErrorInvalid
}

protocol TrackerCoreDataStoreDelegate: AnyObject {
    func store()
}

class TrackerCoreDataStore: NSObject, NSFetchedResultsControllerDelegate {
    weak var delegate: TrackerCoreDataStoreDelegate?
    static let shared = TrackerCoreDataStore()
    
    var filterPredicates = [NSPredicate]()
    var textPredicate: NSPredicate?
    var datePredecate: NSPredicate?
    
    var trackers: [Tracker] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({ try self.tracker(from: $0) })
        else { return [] }
        return trackers
    }
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
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
    }
    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        delegate?.store()
    }
    
    private func tracker(from trackersCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackersCoreData.uuid else {
            throw TrackerStoreError.decodingErrorInvalidId
        }
        
        guard let title = trackersCoreData.action else {
            throw TrackerStoreError.decodingErrorInvalidTitle
        }
        
        guard let color = trackersCoreData.color else {
            throw TrackerStoreError.decodingErrorInvalidColor
        }
        
        guard let emoji = trackersCoreData.emoji else {
            throw TrackerStoreError.decodingErrorInvalidEmoji
        }
        
        guard let schedule = trackersCoreData.schedule else {
            throw TrackerStoreError.decodingErrorInvalidSchedule
        }
        
        return Tracker(
            id: id,
            action: title,
            color: color as! UIColor,
            emoji: emoji,
            schedule: schedule as! [DayOfWeek : Bool])
    }}
extension TrackerCoreDataStore {
  
    

}

