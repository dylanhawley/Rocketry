//
//  WeatherManager.swift
//  T Minus
//
//  Created by Dylan Hawley on 11/14/24.
//

import Foundation
import WeatherKit

class WeatherManager {
    static let shared = WeatherManager()
    let service = WeatherService.shared
    
    func weatherAttribution() async -> WeatherAttribution? {
        let attribution = await Task(priority: .userInitiated) {
            return try? await self.service.attribution
        }.value
        return attribution
    }
}
