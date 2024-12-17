//
//  LivestreamView.swift
//  Rocketry
//
//  Created by Dylan Hawley on 12/9/24.
//

import SwiftUI

struct LivestreamView: View {
    let source: LaunchDetailed.VidURL
    
    var body: some View {
        Link(destination: URL(string: source.url)!) {
            AsyncImage(url: URL(string: source.feature_image), transaction: Transaction(animation: .spring)) {
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
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                        .aspectRatio(16/9, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
    }
}

//#Preview {
//    LivestreamView()
//}
