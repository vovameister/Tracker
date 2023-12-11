//
//  TrackersArray.swift
//  Tracker
//
//  Created by Владимир Клевцов on 8.11.23..
//

import UIKit

var mockCategory1: [TrackerCategory] = [
    TrackerCategory(title: "Uborka", trackers: [
        Tracker(id: UUID(), action: "Tracker One", color: UIColor.red, emoji: "⭐️", schedule: [
            .monday: false,
            .tuesday: true,
            .wednesday: false,
            .thursday: true,
            .friday: false,
            .saturday: true,
            .sunday: true
        ]),
        Tracker(id: UUID(), action: "Tracker Two", color: UIColor.blue, emoji: "⛈", schedule: [
            .monday: true,
            .tuesday: false,
            .wednesday: true,
            .thursday: false,
            .friday: true,
            .saturday: false,
            .sunday: false
        ]),
        Tracker(id: UUID(), action: "Tracker Three", color: UIColor.green, emoji: "🔥", schedule: [
            
            .monday: true,
            .tuesday: true,
            .wednesday: false,
            .thursday: false,
            .friday: false,
            .saturday: true,
            .sunday: true
        ])
    ]),
    TrackerCategory(title: "CryTime", trackers: [
        Tracker(id: UUID(), action: "someName", color: UIColor.brown, emoji: ":)", schedule: [
            .monday: false,
            .tuesday: true,
            .wednesday: false,
            .thursday: true,
            .friday: false,
            .saturday: true,
            .sunday: false
        ])
    ])
]
let eventMockShudle: [DayOfWeek: Bool] = [
    .monday: true,
    .tuesday: true,
    .wednesday: true,
    .thursday: true,
    .friday: true,
    .saturday: true,
    .sunday: true
]
