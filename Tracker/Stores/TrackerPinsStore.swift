//
//  TrackerPinsStore.swift
//  Tracker
//
//  Created by Владимир Клевцов on 7.1.24..
//

import CoreData
import UIKit

final class TrackerPinsStore {
    private let context: NSManagedObjectContext
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    func fetchAllPins() -> [UUID] {
        let fetchRequest: NSFetchRequest<TrackerPins> = TrackerPins.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pin == %@", NSNumber(value: true))
        
        do {
            let pins = try context.fetch(fetchRequest)
            
            let uuids = pins.compactMap { trackerPin in
                return trackerPin.uuid
            }
            
            return uuids
        } catch {
            print("Error fetching pins: \(error.localizedDescription)")
            return []
        }
    }
    
    func addPin(id: UUID, pin: Bool) {
        deleteItems(id: id)
        
        let newRecord = TrackerPins(context: context)
        newRecord.pin = pin
        newRecord.uuid = id
        do {
            try context.save()
        } catch {
            print("Error saving record: \(error.localizedDescription)")
        }
    }
    func deleteItems(id: UUID) {
        if let existingRecord = fetchPin1(id: id) {
            context.delete(existingRecord)
        }
        do {
            try context.save()
        } catch {
            print("Error saving context after deletion: \(error)")
        }
    }
    
    func fetchPin(id: UUID) -> Bool? {
        let fetchRequest: NSFetchRequest<TrackerPins> = TrackerPins.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", id as CVarArg)
        
        do {
            let pins = try context.fetch(fetchRequest)
            return pins.first?.pin
        } catch {
            print("Error fetching pin: \(error.localizedDescription)")
            return nil
        }
    }
    private func fetchPin1(id: UUID) -> TrackerPins? {
        let fetchRequest: NSFetchRequest<TrackerPins> = TrackerPins.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", id as CVarArg)
        
        do {
            let pins = try context.fetch(fetchRequest)
            return pins.first
        } catch {
            print("Error fetching pin: \(error.localizedDescription)")
            return nil
        }
    }
}
