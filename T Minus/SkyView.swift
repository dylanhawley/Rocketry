//
//  SkyView.swift
//  T Minus
//
//  Created by Dylan Hawley on 10/21/24.
//

import SwiftUI
import CoreLocation
import Solar

struct SkyView: View {
    let date: Date
    let location: CLLocationCoordinate2D
    let backgroundTopStops: [Gradient.Stop]
    let backgroundBottomStops: [Gradient.Stop]
    
    /// Normalize the time of day to be in the range `[0, 1]`.
    static func normalizeTimeOfDay(_ date: Date) -> Double {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let timeInterval = date.timeIntervalSince(startOfDay)
        return timeInterval / (24 * 60 * 60)
    }
    
    init(date: Date, location: CLLocationCoordinate2D) {
        self.date = date
        self.location = location
        
        let solar = Solar(for: self.date, coordinate: self.location)
        let daytimeStart: Date? = Calendar.current.date(byAdding: .hour, value: 1, to: (solar?.sunrise)!)
        let daytimeEnd: Date? = Calendar.current.date(byAdding: .hour, value: -1, to: (solar?.sunset)!)
        
        let astronomicalDawnNormalized: Double = solar?.astronomicalSunrise.map{SkyView.normalizeTimeOfDay($0)} ?? 0.25
        let astronomicalDuskNormalized: Double = solar?.astronomicalSunset.map{SkyView.normalizeTimeOfDay($0)} ?? 0.82
        let daytimeStartNormalized: Double = daytimeStart.map{SkyView.normalizeTimeOfDay($0)} ?? 0.38
        let daytimeEndNormalized: Double = daytimeEnd.map{SkyView.normalizeTimeOfDay($0)} ?? 0.7
        let sunriseNormalized: Double = solar?.sunrise.map{SkyView.normalizeTimeOfDay($0)} ?? 0.33
        let sunsetNormalized: Double = solar?.sunset.map{SkyView.normalizeTimeOfDay($0)} ?? 0.78
        
        self.backgroundTopStops = [
            .init(color: .midnightStart, location: 0),
            .init(color: .midnightStart, location: astronomicalDawnNormalized),
            .init(color: .sunriseStart, location: sunriseNormalized),
            .init(color: .sunnyDayStart, location: daytimeStartNormalized),
            .init(color: .sunnyDayStart, location: daytimeEndNormalized),
            .init(color: .sunsetStart, location: sunsetNormalized),
            .init(color: .midnightStart, location: astronomicalDuskNormalized),
            .init(color: .midnightStart, location: 1)
        ]
        self.backgroundBottomStops = [
            .init(color: .midnightEnd, location: 0),
            .init(color: .midnightEnd, location: astronomicalDawnNormalized),
            .init(color: .sunriseEnd, location: sunriseNormalized),
            .init(color: .sunnyDayEnd, location: daytimeStartNormalized),
            .init(color: .sunnyDayEnd, location: daytimeEndNormalized),
            .init(color: .sunsetEnd, location: sunsetNormalized),
            .init(color: .midnightEnd, location: astronomicalDuskNormalized),
            .init(color: .midnightEnd, location: 1)
        ]
    }

    var body: some View {
        LinearGradient(colors: [
            backgroundTopStops.interpolated(amount: SkyView.normalizeTimeOfDay(date)),
            backgroundBottomStops.interpolated(amount: SkyView.normalizeTimeOfDay(date))
        ], startPoint: .top, endPoint: .bottom)
    }
}

#Preview {
    SkyView(date: Date(timeIntervalSinceNow: 1*60*60), location: CLLocationCoordinate2D(latitude: 43, longitude: -76))
}
