//
//  ContentView.swift
//  Launch Feed
//
//  Created by Dylan Hawley on 10/16/23.
//

import SwiftUI

struct Launch: Hashable, Codable {
    var id: String
    var name: String
    var last_updated: String
    var net: String
    var window_end: String
    var window_start: String
    var holdreason: String
    var failreason: String
    var image: String
}

struct LL2Response: Hashable, Codable {
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
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        if let date = Self.iso8601DateFormatter.date(from: iso8601String) {
            Text(Self.dateFormatter.string(from: date))
        } else {
            Text("Invalid date")
        }
    }
}


struct CardView: View {
    var launch: Launch
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(launch.name)
                .font(.headline)
                .padding(.top, 8)
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
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
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
