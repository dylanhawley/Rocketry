//
//  LivestreamView.swift
//  Rocketry
//
//  Created by Dylan Hawley on 12/9/24.
//

import SwiftUI

struct LivestreamView: View {
    let source: URL
    
    @State private var detailedLaunch: LaunchDetailed? = nil
    
    var body: some View {
        VStack() {
            if let detailedLaunch = detailedLaunch {
                let vidURLs = detailedLaunch.vidURLs
                if !vidURLs.isEmpty {
                    let highestPriorityVideo = vidURLs.max(by: { $0.priority < $1.priority })
                    Link(destination: URL(string: highestPriorityVideo!.url)!) {
                        AsyncImage(url: URL(string: highestPriorityVideo!.feature_image), transaction: Transaction(animation: .spring)) {
                            phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        Image(systemName: "play.fill")
                                            .padding()
                                            .foregroundColor(.white)
                                            .font(.largeTitle)
                                            .background(.ultraThinMaterial, in: Circle())
                                    )
                            default:
                                EmptyView()
                            }
                        }
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
        }
        .onAppear {
            Task { await fetchVideoURL() }
        }
    }
    
    // Asynchronous function to fetch and decode detailed launch info from launch.url
    private func fetchVideoURL() async {
        print("fetching vidurls")
        do {
            let (data, _) = try await URLSession.shared.data(from: source)
            let decoded = try JSONDecoder().decode(LaunchDetailed.self, from: data)
            await MainActor.run {
                self.detailedLaunch = decoded
            }
        } catch {
            // Handle error (e.g., show an alert or log the error)
            print("Failed to fetch or decode detailed launch data: \(error)")
        }
    }
}

//#Preview {
//    LivestreamView()
//}
