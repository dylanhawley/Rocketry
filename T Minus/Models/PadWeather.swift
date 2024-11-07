//
//  PadWeather.swift
//  T Minus
//
//  Created by Dylan Hawley on 11/5/24.
//

import WeatherKit


struct PadWeather: Codable {
    var cloudCover: Double
    var symbolName: String
    var precipitationChance: Double
    var temperature: Double
    var cloudThickness: Cloud.Thickness{
        switch cloudCover {
            case 0.05...0.25:
                return .thin
            case 0.25...0.5:
                return .light
            case 0.5...1:
                return .regular
            default:
                return .none
        }
    }
}
