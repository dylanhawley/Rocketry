//
//  WeatherModel.swift
//  Rocketry
//
//  Created by Dylan Hawley on 11/5/24.
//

import WeatherKit

struct WeatherModel: Codable {
    /// The percentage of the sky covered with clouds.
    ///
    /// The value is from `0` (no cloud cover)  to `1` (complete cloud cover).
    ///
    var cloudCover: Double
    
    /// A description of the weather condition for this hour.
    var condition: WeatherCondition
    
    /// The SF Symbol icon that represents the hour weather condition and whether it's daylight on the hour.
    var symbolName: String
    
    /// The humidity for the hour.
    ///
    /// Relative humidity measures the amount of water vapor in the air compared to the maximum
    /// amount that the air could normally hold at the current temperature.  The value is from `0` (no humidity)
    ///  to `1` (100% humidity).
    var humidity: Double
    
    /// The presence or absence of daylight at the requested location and hour.
    var isDaylight: Bool
    
    /// The probability of precipitation during the hour.
    ///
    /// The value is from `0` (0% probability) to `1` (100% probability).
    var precipitationChance: Double
    
    /// The temperature during the hour. (in Celsius)
    var temperature: Double
    
    /// The apparent, or "feels like" temperature during the hour. (in Celsius)
    var apparentTemperature: Double
    
    /// The expected intensity of ultraviolet radiation from the sun.
    var uvIndex: Int
    
    /// The distance at which an object can be clearly seen. (in Meters)
    ///
    /// The amount of light and weather conditions like fog, mist, and smog affect visibility.
    var visibility: Double
    
    var cloudThickness: Cloud.Thickness{
        switch cloudCover {
            case 0.125...0.375:
                return .thin
            case 0.375...0.625:
                return .light
            case 0.625...0.875:
                return .regular
            case 0.875...1:
                return .thick
            default:
                return .none
        }
    }
}

extension WeatherModel {
    init(hourWeather: HourWeather) {
        self.cloudCover = hourWeather.cloudCover
        self.condition = hourWeather.condition
        self.symbolName = hourWeather.symbolName
        self.humidity = hourWeather.humidity
        self.isDaylight = hourWeather.isDaylight
        self.precipitationChance = hourWeather.precipitationChance
        self.temperature = hourWeather.temperature.converted(to: .celsius).value
        self.apparentTemperature = hourWeather.apparentTemperature.converted(to: .celsius).value
        self.uvIndex = hourWeather.uvIndex.value
        self.visibility = hourWeather.visibility.converted(to: .meters).value
    }
}
