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
    
    func addRecord(id: UUID, date: Date) {
        let newRecord = TrackerRecordCD(context: context)
        newRecord.trackerID = id
        newRecord.date = date
        
        do {
            try context.save()
        } catch {
            print("Error saving record: \(error.localizedDescription)")
        }
    }
    
    func removeTracker(date: Date, uuid: UUID) {
        let fetchRequest: NSFetchRequest<TrackerRecordCD> = TrackerRecordCD.fetchRequest()
        let calendar = Calendar.current
        let beginningOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: beginningOfDay)
        
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@ AND trackerID == %@", beginningOfDay as CVarArg, endOfDay! as CVarArg, uuid as CVarArg)
        
        do {
            let records = try context.fetch(fetchRequest)
            for record in records {
                context.delete(record)
            }
            
            try context.save()
        } catch {
            print("Error removing tracker: \(error.localizedDescription)")
        }
    }
    func deleteItems(id: UUID) {
        if let recordsToDelete = fetchRecord(id: id) {
            for existingRecord in recordsToDelete {
                context.delete(existingRecord)
            }
            
            do {
                try context.save()
            } catch {
                print("Error saving context after deletion: \(error)")
            }
        }
    }
    private func fetchRecord(id: UUID) -> [TrackerRecordCD]? {
        let fetchRequest: NSFetchRequest<TrackerRecordCD> = TrackerRecordCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackerID == %@", id as CVarArg)
        
        do {
            let records = try context.fetch(fetchRequest)
            return records
        } catch {
            print("Error fetching pin: \(error.localizedDescription)")
            return nil
        }
    }
    func hasTracker(date: Date, uuid: UUID) -> Bool {
        let fetchRequest: NSFetchRequest<TrackerRecordCD> = TrackerRecordCD.fetchRequest()
        
        let calendar = Calendar.current
        let beginningOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: beginningOfDay)
        
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@ AND trackerID == %@", beginningOfDay as CVarArg, endOfDay! as CVarArg, uuid as CVarArg)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error fetching tracker: \(error.localizedDescription)")
            return false
        }
    }
    func hasTracker1(for tracker: Tracker, on date: Date) -> Bool {
        let calendar = Calendar.current
        let beginningOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: beginningOfDay)
        
        let fetchRequest: NSFetchRequest<TrackerRecordCD> = TrackerRecordCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@ AND trackerID == %@", beginningOfDay as CVarArg, endOfDay! as CVarArg, tracker.id as CVarArg)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error fetching tracker: \(error.localizedDescription)")
            return false
        }
    }
    
    func sumOfRecords(uuid: UUID) -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCD> = TrackerRecordCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackerID == %@", uuid as CVarArg)
        
        do {
            let records = try context.fetch(fetchRequest)
            return records.count
        } catch {
            print("Error fetching records: \(error.localizedDescription)")
            return 0
        }
    }
    func sumOfAllRecords() -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCD> = TrackerRecordCD.fetchRequest()
        do {
            let records = try context.fetch(fetchRequest)
            return records.count
        } catch {
            print("Error fetching records: \(error.localizedDescription)")
            return 0
        }
    }
}
