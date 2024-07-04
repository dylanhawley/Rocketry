//
//  ContentView.swift
//  T Minus
//
//  Created by Dylan Hawley on 10/16/23.
//

import SwiftUI


class ViewModel: ObservableObject {
    @Published var launches: [Launch] = []

    private let dataService: DataService

    init(dataService: DataService = NetworkDataService()) {
        self.dataService = dataService
    }

    func fetch() {
        dataService.fetchLaunches { [weak self] launches in
            DispatchQueue.main.async {
                self?.launches = launches
            }
        }
    }
}

protocol DataService {
    func fetchLaunches(completion: @escaping ([Launch]) -> Void)
}

class NetworkDataService: DataService {
    func fetchLaunches(completion: @escaping ([Launch]) -> Void) {
        guard let url = URL(string: "https://lldev.thespacedevs.com/2.2.0/launch/upcoming/") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }

            // Convert to JSON
            do {
                let launches = try JSONDecoder().decode(LL2Response.self, from: data)
                completion(launches.results)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

class MockDataService: DataService {
    func fetchLaunches(completion: @escaping ([Launch]) -> Void) {
        if let url = Bundle.main.url(forResource: "mockLaunches", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let launches = try JSONDecoder().decode(LL2Response.self, from: data)
                completion(launches.results)
            } catch {
                print("Error reading or decoding mockLaunches.json: \(error)")
                completion([])
            }
        } else {
            print("mockLaunches.json not found")
            completion([])
        }
    }
}

struct FormattedDateView: View {
    let iso8601String: String

    static let iso8601DateFormatter: ISO8601DateFormatter = ISO8601DateFormatter()

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
        let date = Self.iso8601DateFormatter.date(from: iso8601String)
        if let date = date {
            DateView(date: date)
        } else {
            Text("Invalid date")
        }
    }

    private func DateView(date: Date) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "calendar")
                Text(Self.dateFormatter.string(from: date))
            }
            HStack {
                Image(systemName: "clock")
                Text(Self.timeFormatter.string(from: date))
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
    @StateObject var viewModel: ViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.launches, id: \.id) { launch in
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
    ContentView(viewModel: ViewModel(dataService: MockDataService()))
}
