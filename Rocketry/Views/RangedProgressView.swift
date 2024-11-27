//
//  RangedProgressView.swift
//  Rocketry
//
//  Created by Dylan Hawley on 11/26/24.
//

import SwiftUI

struct RangedProgressView: ProgressViewStyle {
    let range: ClosedRange<Double>
    let foregroundColor: AnyShapeStyle
    let backgroundColor: Color

    func makeBody(configuration: Configuration) -> some View {
        return GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(backgroundColor)
                
                Capsule()
                    .fill(foregroundColor)
                    .frame(width: proxy.size.width * fillWidthScale)
                    .offset(x: proxy.size.width * range.lowerBound)
                
                Circle()
                    .foregroundColor(backgroundColor)
                    .frame(width: proxy.size.height + 4.0, height: proxy.size.height + 4.0)
                    .position(
                        x: proxy.size.width * (configuration.fractionCompleted ?? 0.0),
                        y: proxy.size.height / 2.0
                    )
                
                Circle()
                    .foregroundColor(.white)
                    .position(
                        x: proxy.size.width * (configuration.fractionCompleted ?? 0.0),
                        y: proxy.size.height / 2.0
                    )
            }
            .clipped()
        }
    }

    var fillWidthScale: Double {
        let normalizedRange = range.upperBound - range.lowerBound
        return Double(normalizedRange)
    }
}

#Preview {
    ProgressView(value: 0.3)
        .progressViewStyle(RangedProgressView(range: 0.2...0.4, foregroundColor: AnyShapeStyle(Color.blue), backgroundColor: Color.gray))
        .frame(maxHeight: 5)
}
