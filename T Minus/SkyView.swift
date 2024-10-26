//
//  SkyView.swift
//  T Minus
//
//  Created by Dylan Hawley on 10/21/24.
//

import SwiftUI
import CoreLocation
import Solar

class SolarTime {
    /// Normalize the time of day to be in the range `[0, 1]`.
    static func normalizeTimeOfDay(_ date: Date, _ timeZone: TimeZone) -> Double {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        let startOfDay = calendar.startOfDay(for: date)
        let timeInterval = date.timeIntervalSince(startOfDay)
        return timeInterval / (24 * 60 * 60)
    }
    
    static func getTimeZone(location: CLLocationCoordinate2D, completion: @escaping ((TimeZone) -> Void)) {
        let cllLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(cllLocation) { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let placemarks = placemarks {
                    if let optTime = placemarks.first!.timeZone {
                        completion(optTime)
                    }
                }
            }
        }
    }
}

struct SkyView: View {
    let date: Date
    let location: CLLocationCoordinate2D
    
    @State private var backgroundTopStops: [Gradient.Stop] = []
    @State private var backgroundBottomStops: [Gradient.Stop] = []
    @State private var normalizedTimeOfDay: Double = 0
    
    var body: some View {
        Group {
            if !backgroundTopStops.isEmpty && !backgroundBottomStops.isEmpty {
                LinearGradient(colors: [
                    backgroundTopStops.interpolated(amount: normalizedTimeOfDay),
                    backgroundBottomStops.interpolated(amount: normalizedTimeOfDay)
                ], startPoint: .top, endPoint: .bottom)
            } else {
                Color(.secondarySystemBackground)
            }
        }
        .onAppear {
            fetchTimeZoneAndCompute()
        }
    }
    
    private func fetchTimeZoneAndCompute() {
        SolarTime.getTimeZone(location: location) { timeZone in
            computeGradientStops(localTimeZone: timeZone)
        }
    }
    
    private func computeGradientStops(localTimeZone: TimeZone) {
        let solar = Solar(for: date, coordinate: location)
        let daytimeStart: Date? = Calendar.current.date(byAdding: .hour, value: 1, to: (solar?.sunrise)!)
        let daytimeEnd: Date? = Calendar.current.date(byAdding: .hour, value: -1, to: (solar?.sunset)!)
        let normalizedTime = SolarTime.normalizeTimeOfDay(date, localTimeZone)
        
        let astronomicalDawnNormalized: Double = solar?.astronomicalSunrise.map{SolarTime.normalizeTimeOfDay($0, localTimeZone)} ?? 0.25
        let astronomicalDuskNormalized: Double = solar?.astronomicalSunset.map{SolarTime.normalizeTimeOfDay($0, localTimeZone)} ?? 0.82
        let daytimeStartNormalized: Double = daytimeStart.map{SolarTime.normalizeTimeOfDay($0, localTimeZone)} ?? 0.38
        let daytimeEndNormalized: Double = daytimeEnd.map{SolarTime.normalizeTimeOfDay($0, localTimeZone)} ?? 0.7
        let sunriseNormalized: Double = solar?.sunrise.map{SolarTime.normalizeTimeOfDay($0, localTimeZone)} ?? 0.33
        let sunsetNormalized: Double = solar?.sunset.map{SolarTime.normalizeTimeOfDay($0, localTimeZone)} ?? 0.78
        
        self.normalizedTimeOfDay = normalizedTime
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
}

#Preview {
    SkyView(date: Date(timeIntervalSinceNow: 1*60*60), location: CLLocationCoordinate2D(latitude: 43, longitude: -76))
}
