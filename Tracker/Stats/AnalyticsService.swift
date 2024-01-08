//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Владимир Клевцов on 7.1.24..
//

import Foundation
import YandexMobileMetrica

final class AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "3f3e2ebe-bd77-4b27-991e-a52adac3560d") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    func report(event: String, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }

}
