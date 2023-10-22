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

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.launches, id: \.self) { launch in
                    HStack {
                        AsyncImage(url: URL(string: launch.image))
                            .frame(width: 120, height: 70)
                            .background(Color.gray)
                            .clipped()
                        Text(launch.name)
                            .bold()
                    }
                }
            }
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
