//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Владимир Клевцов on 23.11.23..
//
import CoreData
import UIKit

final class RecordStore {
    private let context: NSManagedObjectContext

    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func addNewTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCD(context: context)
        updateTrackerRecordCoreData(trackerRecordCoreData, with: trackerRecord)
        try context.save()
    }

    func updateTrackerRecordCoreData(_ trackerRecordCoreData: TrackerRecordCD, with trackerRecord: TrackerRecord) {
        trackerRecordCoreData.trackerID = trackerRecord.trackerId
        trackerRecordCoreData.date = trackerRecord.date
    }
}
