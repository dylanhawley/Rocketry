//
//  ContentView.swift
//  Launch Feed
//
//  Created by Dylan Hawley on 10/16/23.
//

import SwiftUI

struct Launch: Hashable, Decodable {
    var id: String
    var name: String
    var last_updated: String
    var net: String
    var window_end: String
    var window_start: String
    var holdreason: String
    var failreason: String
    var rocket: Rocket
    var mission: Mission
    var pad: Pad
    var image: String
    
    struct Rocket: Hashable, Decodable {
        var configuration: RocketConfiguration
        
        struct RocketConfiguration: Hashable, Decodable {
            var url: String
            var name: String
            var family: String
            var full_name: String
            var variant: String
        }
    }
    
    struct Mission: Hashable, Decodable {
        var name: String
        var description: String
        var type: String
        
        struct Orbit: Hashable, Decodable {
            var name: String
            var abbrev: String
        }
    }

    struct Pad: Hashable, Decodable {
        var name: String
        var map_url: String
        var latitude: String
        var longitude: String
        var location: Location
        
        struct Location: Hashable, Decodable {
            var name: String
            var country_code: String
            var timezone_name: String
        }
    }
}

struct LL2Response: Decodable {
    var results: [Launch]
}

class ViewModel: ObservableObject {
    @Published var launches: [Launch] = []

    func fetch() {
        guard let url = URL(string: "https://lldev.thespacedevs.com/2.2.0/launch/upcoming/") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return
            }

            // Convert to JSON
            do {
                let launches = try JSONDecoder().decode(LL2Response.self, from: data)
                DispatchQueue.main.async {
                    self?.launches = launches.results
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
}

struct FormattedDateView: View {
    let iso8601String: String
    
    static let iso8601DateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma z"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            if let date = Self.iso8601DateFormatter.date(from: iso8601String) {
                HStack {
                    Image(systemName: "calendar")
                    Text(Self.dateFormatter.string(from: date))
                }
            } else {
                Text("Invalid date")
            }
            if let time = Self.iso8601DateFormatter.date(from: iso8601String) {
                HStack {
                    Image(systemName: "clock")
                    Text(Self.timeFormatter.string(from: time))
                }
            } else {
                Text("Invalid date")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


struct CardView: View {
    var launch: Launch
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(launch.name)
                .font(.headline)
                .padding(.top, 8)
            Divider()
            Text(launch.mission.description)
            FormattedDateView(iso8601String: launch.net)
            AsyncImage(url: URL(string: launch.image)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .cornerRadius(5)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(15)
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.launches, id: \.self) { launch in
                        CardView(launch: launch)
                    }
                }
                .padding()
            }
            .background(Color.gray.opacity(0.1))
            .navigationTitle("Launches")
            .onAppear {
                viewModel.fetch()
            }
        }
    }
}

#Preview {
    ContentView()
}
