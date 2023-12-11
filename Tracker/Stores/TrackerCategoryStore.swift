//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Владимир Клевцов on 23.11.23..
//

import CoreData
import UIKit

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext
    static let shared = TrackerCategoryStore()
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addNewTrackerCategory(_ trackerCategory: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCD(context: context)
        updateTrackerCategoryCoreData(trackerCategoryCoreData, with: trackerCategory)
        try context.save()
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
    
}







