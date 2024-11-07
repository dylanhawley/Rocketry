//
//  LaunchRow.swift
//  T Minus
//
//  Created by Dylan Hawley on 8/27/24.
//

import SwiftUI
import Solar


struct LaunchRow: View {
    var launch: Launch
    @State private var normalizedTimeOfDay: Double = 0
    @State private var isAstronomicalNight: Bool = false
    @State private var cloudTopStops: [Gradient.Stop] = []
    @State private var cloudBottomStops: [Gradient.Stop] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(launch.mission)
                .font(.headline)
            ScrollView(.horizontal) {
                HStack {
                    Text(launch.vehicle)
                        .padding(5)
                        .background(Color(.tertiarySystemFill))
                        .cornerRadius(5)
                    Text(launch.pad)
                        .padding(5)
                        .background(Color(.tertiarySystemFill))
                        .cornerRadius(5)
                }
                .font(.system(size: 16, weight: .light))
            }
            Text(launch.details)
                .font(.system(size: 16, weight: .light))
                .lineLimit(3)
            FormattedDateView(date: launch.net)
                .font(.system(size: 16, weight: .light))
                .opacity(0.8)
        }
        .foregroundStyle(.white)
        .padding()
        .background(
            ZStack {
                SkyView(date: launch.net, location: launch.location.coordinate, timezone_name: launch.timezone_name)
                SunView(progress: normalizedTimeOfDay)
                if isAstronomicalNight { StarsView() }
                else if let weather = launch.weather {
                    if cloudTopStops != [] && cloudBottomStops != [] {
                        CloudsView(thickness: weather.cloudThickness, topTint: cloudTopStops.interpolated(amount: normalizedTimeOfDay), bottomTint: cloudTopStops.interpolated(amount: normalizedTimeOfDay))
                    }
                }
            }
        )
        .cornerRadius(15)
        .onAppear {
            fetchSolarEvents()
        }
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

struct FormattedDateView: View {
    let date: Date

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma z"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        return formatter
    }()

    var body: some View {
        HStack {
            Text(Self.dateFormatter.string(from: date))
            Spacer()
            Text(Self.timeFormatter.string(from: date))
        }
    }
}

#if DEBUG
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        VStack {
            ForEach(Launch.sampleLaunches.prefix(1), id: \.code) { launch in
                LaunchRow(launch: launch)
            }
        }
        .padding()
        .frame(minWidth: 300, alignment: .leading)
    }
}
#endif
