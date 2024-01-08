//
//  Colors.swift
//  Tracker
//
//  Created by Владимир Клевцов on 4.1.24..
//

import UIKit

final class Colors {
    static let shared = Colors()
    
    let bgColor =  UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor(named: "dark") ?? .black
        } else {
            return .white
        }
    }
}
