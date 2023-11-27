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
enum DayOfWeek: Int {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}
