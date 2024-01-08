//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Владимир Клевцов on 23.11.23..
//

import CoreData
import UIKit
enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidTitle
    case decodingErrorInvalidTracker
    case decodingErrorInvalidFetchTitle
    case decodingErrorInvalid
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func categoryStore()
}


final class TrackerCategoryStore: NSObject, NSFetchedResultsControllerDelegate {
    private let context: NSManagedObjectContext
    static let shared = TrackerCategoryStore()
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCD>!
    private let trackerStore = TrackerCoreDataStore()
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    var trackerCategories: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({ try self.trackerCategory(from: $0) })
        else { return [] }
        return trackers
    }
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCategoryCD.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCD.title, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    func saveNewCategory(title: String) {
        let newCategory = TrackerCategoryCD(context: context)
        newCategory.title = title
        
        do {
            try context.save()
        } catch {
            print("Error saving new category: \(error.localizedDescription)")
        }
    }
    func addNewTrackerCategory(_ trackerCategory: TrackerCategory) throws {
        let existingCategory = getTrackerCategory(with: trackerCategory.title)
        
        if let existingCategory = existingCategory {
            
            appendTracker(to: existingCategory, with: trackerCategory)
        } else {
            
            let trackerCategoryCoreData = TrackerCategoryCD(context: context)
            updateTrackerCategoryCoreData(trackerCategoryCoreData, with: trackerCategory)
        }
        
        try context.save()
    }
    
    func getTrackerCategory(with title: String) -> TrackerCategoryCD? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCD> = TrackerCategoryCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            return nil
        }
    }
    func fetchCategoryTitles() -> [String] {
        let fetchRequest: NSFetchRequest<TrackerCategoryCD> = TrackerCategoryCD.fetchRequest()
        
        do {
            let categories = try context.fetch(fetchRequest)
            let categoryTitles = categories.map { $0.title ?? "" }
            return categoryTitles
        } catch {
            print("Error fetching category titles: \(error.localizedDescription)")
            return []
        }
    }
    func appendTracker(to category: TrackerCategoryCD, with trackerCategory: TrackerCategory) {
        
        
        let trackerCoreDataArray = trackerCategory.trackers.map { tracker in
            let trackerCoreData = TrackerCoreData(context: context)
            trackerCoreData.uuid = tracker.id
            trackerCoreData.action = tracker.action
            trackerCoreData.color = tracker.color
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.schedule = tracker.schedule as NSObject
            
            return trackerCoreData
        }
        
        let existingTrackers = category.mutableSetValue(forKey: "trackers")
        existingTrackers.addObjects(from: trackerCoreDataArray)
    }
    
    func updateTrackerCategoryCoreData(_ trackerCategoryCoreData: TrackerCategoryCD, with trackerCategory: TrackerCategory) {
        trackerCategoryCoreData.title = trackerCategory.title
        
        let trackerCoreDataArray = trackerCategory.trackers.map { tracker in
            let trackerCoreData = TrackerCoreData(context: context)
            trackerCoreData.uuid = tracker.id
            trackerCoreData.action = tracker.action
            trackerCoreData.color = tracker.color
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.schedule = tracker.schedule as NSObject
            
            
            return trackerCoreData
        }
        
        trackerCategoryCoreData.trackers = NSSet(array: trackerCoreDataArray)
    }
    private func trackerCategory(from trackersCategoryCoreData: TrackerCategoryCD) throws -> TrackerCategory {
        guard let title = trackersCategoryCoreData.title else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTitle
        }
        
        guard let trackerCoreDataArray = trackersCategoryCoreData.trackers?.allObjects as? [TrackerCoreData] else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTracker
        }
        let filteredTrackers = trackerCoreDataArray.filter { trackerCoreData in
            
            return trackerCoreData.categorys?.title == title
        }
        
        let trackers = try filteredTrackers.map { try trackerStore.tracker(from: $0) }
        
        return TrackerCategory(
            title: title,
            trackers: trackers
        )
    }
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        delegate?.categoryStore()
    }
    func deleteTrackerFromCategories(id: UUID) {
          guard let trackerCoreData = TrackerCoreDataStore.shared.fetchTracker(id: id) else {
              return
          }
          
          for category in fetchedResultsController.fetchedObjects ?? [] {
              if let trackers = category.trackers?.allObjects as? [TrackerCoreData] {
                  let mutableTrackers = NSMutableSet(array: trackers)
                  mutableTrackers.remove(trackerCoreData)
                  category.trackers = mutableTrackers
                  
                  do {
                      try context.save()
                  } catch {
                      print("Error saving context after deleting tracker from category: \(error.localizedDescription)")
                  }
              }
          }
      }
        func deleteCategory(withTitle title: String) {
            guard let categoryToDelete = getTrackerCategory(with: title) else {
                return
            }

            context.delete(categoryToDelete)

            do {
                try context.save()
            } catch {
                print("Error saving context after deleting category: \(error.localizedDescription)")
            }
        }
    func editCategory(oldTitle: String, newTitle: String) {
        guard let categoryToDelete = getTrackerCategory(with: oldTitle) else {
            return
        }
        categoryToDelete.title = newTitle
        
        do {
            try context.save()
        } catch {
            print("Error saving context after deleting category: \(error.localizedDescription)")
        }
    }
}





