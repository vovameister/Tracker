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
