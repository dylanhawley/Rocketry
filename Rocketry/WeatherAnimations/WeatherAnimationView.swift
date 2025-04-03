//
//  WeatherAnimationView.swift
//  Rocketry
//
//  Created by Dylan Hawley on 11/27/24.
//

import SwiftUI
import Solar
import CoreLocation

struct WeatherAnimationView: View {
    let date: Date
    let timezone: TimeZone
    let location: CLLocationCoordinate2D
    
    let weather: WeatherModel?
    
    init(launch: Launch) {
        self.date = launch.net
        self.timezone = TimeZone(identifier: launch.timezone_name) ?? .current
        self.location = launch.location.coordinate
        self.weather = launch.weather
    }
    
    @State private var normalizedTimeOfDay: Double = 0
    @State private var astroDawn: Double = 0
    @State private var astroDusk: Double = 0
    @State private var cloudTopStops: [Gradient.Stop] = []
    @State private var cloudBottomStops: [Gradient.Stop] = []
    
    var body: some View {
        ZStack {
            SkyView(date: date, location: location, timezone_name: timezone.identifier)
            if let weather = weather, [.regular, .thick, .ultra].contains(weather.cloudThickness) {
                if weather.isDaylight {
                    Color(hue: 0.58, saturation: 0.15, brightness: 0.74)
                } else {
                    Color(hue: 0.62, saturation: 0.33, brightness: 0.24)
                }
            } else {
                SunView(progress: normalizedTimeOfDay)
            }
            if normalizedTimeOfDay < astroDawn || normalizedTimeOfDay > astroDusk { StarsView() }
            if let weather = weather, !cloudTopStops.isEmpty, !cloudBottomStops.isEmpty {
                CloudsView(thickness: weather.cloudThickness, topTint: cloudTopStops.interpolated(amount: normalizedTimeOfDay), bottomTint: cloudTopStops.interpolated(amount: normalizedTimeOfDay))
                
                if weather.isDaylight {
                    switch weather.cloudThickness {
                    case .regular, .thick, .ultra:
                        Color.black.opacity(0.15)
                    case .light:
                        Color.black.opacity(0.1)
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .onAppear { computeGradientStops() }
    }
    
    private func normalizeTimeOfDay(_ date: Date, _ timezone: TimeZone) -> Double {
        var calendar = Calendar.current
        calendar.timeZone = timezone
        let startOfDay = calendar.startOfDay(for: date)
        let timeInterval = date.timeIntervalSince(startOfDay)
        return timeInterval / (24 * 60 * 60)
    }
    
    private func computeGradientStops() {
        self.normalizedTimeOfDay = normalizeTimeOfDay(date, timezone)
        
        let solar = Solar(for: date, coordinate: location)
        
        let daytimeStart: Date? = Calendar.current.date(byAdding: .hour, value: 1, to: (solar?.sunrise)!)
        let daytimeEnd: Date? = Calendar.current.date(byAdding: .hour, value: -1, to: (solar?.sunset)!)
        let astronomicalDawnNormalized: Double = solar?.astronomicalSunrise.map{normalizeTimeOfDay($0, timezone)} ?? 0.25
        let astronomicalDuskNormalized: Double = solar?.astronomicalSunset.map{normalizeTimeOfDay($0, timezone)} ?? 0.82
        let daytimeStartNormalized: Double = daytimeStart.map{normalizeTimeOfDay($0, timezone)} ?? 0.38
        let daytimeEndNormalized: Double = daytimeEnd.map{normalizeTimeOfDay($0, timezone)} ?? 0.7
        let sunriseNormalized: Double = solar?.sunrise.map{normalizeTimeOfDay($0, timezone)} ?? 0.33
        let sunsetNormalized: Double = solar?.sunset.map{normalizeTimeOfDay($0, timezone)} ?? 0.78
        
        self.astroDawn = astronomicalDawnNormalized
        self.astroDusk = astronomicalDuskNormalized
        self.cloudTopStops = [
            .init(color: .darkCloudStart, location: 0),
            .init(color: .darkCloudStart, location: astronomicalDawnNormalized),
            .init(color: .sunriseCloudStart, location: sunriseNormalized),
            .init(color: .lightCloudStart, location: daytimeStartNormalized),
            .init(color: .lightCloudStart, location: daytimeEndNormalized),
            .init(color: .sunsetCloudStart, location: sunsetNormalized),
            .init(color: .darkCloudStart, location: astronomicalDuskNormalized),
            .init(color: .darkCloudStart, location: 1)
        ]
        self.cloudBottomStops = [
            .init(color: .darkCloudEnd, location: 0),
            .init(color: .darkCloudEnd, location: astronomicalDawnNormalized),
            .init(color: .sunriseCloudEnd, location: sunriseNormalized),
            .init(color: .lightCloudEnd, location: daytimeStartNormalized),
            .init(color: .lightCloudEnd, location: daytimeEndNormalized),
            .init(color: .sunsetCloudEnd, location: sunsetNormalized),
            .init(color: .darkCloudEnd, location: astronomicalDuskNormalized),
            .init(color: .darkCloudEnd, location: 1)
        ]
    }
}

//#Preview {
//    WeatherAnimationView()
//}
