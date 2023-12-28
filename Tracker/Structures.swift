//
//  Structures.swift
//  Tracker
//
//  Created by Владимир Клевцов on 4.11.23..
//

import UIKit

struct Tracker {
    let id: UUID
    let action: String
    let color: UIColor
    let emoji: String
    var schedule: [DayOfWeek: Bool]
}
struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
}
struct TrackerRecord {
    let trackerId: UUID
    let date: Date
}
enum DayOfWeek: String, Codable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var name: String {
        return self.rawValue.capitalized
    }
    var intValue: Int {
        switch self {
        case .monday: return 0
        case .tuesday: return 1
        case .wednesday: return 2
        case .thursday: return 3
        case .friday: return 4
        case .saturday: return 5
        case .sunday: return 6
        }
    }
    init?(intValue: Int) {
        switch intValue {
        case 0: self = .monday
        case 1: self = .tuesday
        case 2: self = .wednesday
        case 3: self = .thursday
        case 4: self = .friday
        case 5: self = .saturday
        case 6: self = .sunday
        default: return nil
        }
    }
}



