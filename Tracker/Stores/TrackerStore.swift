//
//  TrackerStore.swift
//  Tracker
//
//  Created by Владимир Клевцов on 23.11.23..
//
import CoreData
import UIKit

final class TrackerStore {
    private let context: NSManagedObjectContext

    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func addNewTracker(_ tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        updateTrackerCoreData(trackerCoreData, with: tracker)
        try context.save()
    }

    func updateTrackerCoreData(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) {
        trackerCoreData.id = tracker.id
        trackerCoreData.action = tracker.action
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji

        if let data = try? NSKeyedArchiver.archivedData(withRootObject: tracker.schedule, requiringSecureCoding: false) {
            trackerCoreData.schedule = data
        }
    }
}
