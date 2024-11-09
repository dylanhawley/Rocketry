//
//  LaunchDetailView.swift
//  T Minus
//
//  Created by Dylan Hawley on 11/7/24.
//

import SwiftUI
import Solar

struct LaunchDetailView: View {
    let launch: Launch
    @Environment(\.dismiss) private var dismiss
    @State private var normalizedTimeOfDay: Double = 0
    @State private var isAstronomicalNight: Bool = false
    @State private var cloudTopStops: [Gradient.Stop] = []
    @State private var cloudBottomStops: [Gradient.Stop] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header with background
                VStack(alignment: .leading) {
                    Text(launch.mission)
                        .font(.largeTitle)
                        .bold()
                    FormattedDateView(date: launch.net)
                        .font(.title3)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .frame(height: 200)
                
                // Launch details
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Vehicle")
                            .font(.headline)
                        Text(launch.vehicle)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Launch Site")
                            .font(.headline)
                        Text(launch.pad)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Orbit")
                            .font(.headline)
                        Text(launch.orbit)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mission Details")
                            .font(.headline)
                        Text(launch.details)
                    }
                }
                .padding()
            }
        }
        .foregroundStyle(.white)
        .onAppear {
            fetchSolarEvents()
        }
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                SkyView(date: launch.net, location: launch.location.coordinate, timezone_name: launch.timezone_name)
                SunView(progress: normalizedTimeOfDay)
                if isAstronomicalNight { StarsView() }
                else if let weather = launch.weather, !cloudTopStops.isEmpty, !cloudBottomStops.isEmpty {
                    CloudsView(thickness: weather.cloudThickness, topTint: cloudTopStops.interpolated(amount: normalizedTimeOfDay), bottomTint: cloudTopStops.interpolated(amount: normalizedTimeOfDay))
                }
            }
            .ignoresSafeArea()
        )
    }
    
    private func fetchSolarEvents() {
        let timezone = TimeZone(identifier: launch.timezone_name) ?? .current
        self.normalizedTimeOfDay = SolarTime.normalizeTimeOfDay(launch.net, timezone)
        
        let solar = Solar(for: launch.net, coordinate: launch.location.coordinate)
        if let sunrise = solar?.astronomicalSunrise,
           let sunset = solar?.astronomicalSunset,
           launch.net < sunrise || launch.net > sunset {
            isAstronomicalNight = true
        }
        
        let daytimeStart: Date? = Calendar.current.date(byAdding: .hour, value: 1, to: (solar?.sunrise)!)
        let daytimeEnd: Date? = Calendar.current.date(byAdding: .hour, value: -1, to: (solar?.sunset)!)
        let astronomicalDawnNormalized: Double = solar?.astronomicalSunrise.map{SolarTime.normalizeTimeOfDay($0, timezone)} ?? 0.25
        let astronomicalDuskNormalized: Double = solar?.astronomicalSunset.map{SolarTime.normalizeTimeOfDay($0, timezone)} ?? 0.82
        let daytimeStartNormalized: Double = daytimeStart.map{SolarTime.normalizeTimeOfDay($0, timezone)} ?? 0.38
        let daytimeEndNormalized: Double = daytimeEnd.map{SolarTime.normalizeTimeOfDay($0, timezone)} ?? 0.7
        let sunriseNormalized: Double = solar?.sunrise.map{SolarTime.normalizeTimeOfDay($0, timezone)} ?? 0.33
        let sunsetNormalized: Double = solar?.sunset.map{SolarTime.normalizeTimeOfDay($0, timezone)} ?? 0.78
        
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
//    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
//        LaunchDetailView(launch: Launch.sampleLaunches[2])
//    }
//}
