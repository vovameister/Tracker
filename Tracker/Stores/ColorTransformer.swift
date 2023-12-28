//
//  ColorTransformer.swift
//  Tracker
//
//  Created by Владимир Клевцов on 23.11.23..
//

import UIKit
import CoreData

@objc(ColorTransformer)
class ColorTransformer: NSSecureUnarchiveFromDataTransformer {
    override class var allowedTopLevelClasses: [AnyClass] {
        return [UIColor.self]
    }
    
    static func register() {
        let transformer = ColorTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName(rawValue: String(describing: ColorTransformer.self)))
    }
}
@objc(DaysValueTransformer)
final class DaysValueTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool { true }
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? [DayOfWeek: Bool] else { return nil }
        return try? JSONEncoder().encode(days)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode([DayOfWeek: Bool].self, from: data as Data)
    }
    static func register() {
        ValueTransformer.setValueTransformer(
            DaysValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: DaysValueTransformer.self))
        )
    }
}

