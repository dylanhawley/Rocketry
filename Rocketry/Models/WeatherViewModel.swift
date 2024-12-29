//
//  WeatherViewModel.swift
//  Rocketry
//
//  Created by Dylan Hawley on 12/29/24.
//

import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var currentWeather: WeatherModel?
    
    @AppStorage("cloudCoverFilterEnabledKey") private var cloudCoverFilterEnabled: Bool = true
    @AppStorage("maxCloudCoverKey") private var maxCloudCover: Double = 25
    @AppStorage("visibilityFilterEnabledKey") private var visibilityFilterEnabled: Bool = true
    @AppStorage("minVisibilityKey") private var minVisibility: Double = 13
    @AppStorage("precipitationFilterEnabledKey") private var precipitationFilterEnabled: Bool = true
    @AppStorage("maxPrecipitationChanceKey") private var maxPrecipitationChance: Double = 5
    
    init(weather: WeatherModel?) {
        self.currentWeather = weather
    }
    
    var isGoodViewingConditions: Bool {
        guard let weather = self.currentWeather else { return false }
        if cloudCoverFilterEnabled, weather.cloudCover > (maxCloudCover / 100.0) { return false }
        if visibilityFilterEnabled, weather.visibility < minVisibility { return false }
        if precipitationFilterEnabled, weather.precipitationChance > (maxPrecipitationChance / 100.0) { return false }
        return true
    }
}
