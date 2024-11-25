//
//  CloudsView.swift
//  Rocketry
//
//  Created by Dylan Hawley on 10/18/24.
//

import SwiftUI

struct CloudsView: View {
    var cloudGroup: CloudGroup
    let topTint: Color
    let bottomTint: Color

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, _ in
                cloudGroup.update(date: timeline.date)
                context.opacity = cloudGroup.opacity

                let resolvedImages = (0..<8).map { i -> GraphicsContext.ResolvedImage in
                    let sourceImage = Image("cloud\(i)")
                    var resolved = context.resolve(sourceImage)

                    resolved.shading = .linearGradient(
                        Gradient(colors: [topTint, bottomTint]),
                        startPoint: .zero,
                        endPoint: CGPoint(x: 0, y: resolved.size.height)
                    )

                    return resolved
                }

                for cloud in cloudGroup.clouds {
                    context.translateBy(x: cloud.position.x, y: cloud.position.y)
                    context.scaleBy(x: cloud.scale, y: cloud.scale)
                    context.draw(resolvedImages[cloud.imageNumber], at: .zero, anchor: .topLeading)
                    context.transform = .identity
                }
            }
        }
        .ignoresSafeArea()
    }

    init(thickness: Cloud.Thickness, topTint: Color, bottomTint: Color) {
        cloudGroup = CloudGroup(thickness: thickness)
        self.topTint = topTint
        self.bottomTint = bottomTint
    }
}

#Preview {
    CloudsView(thickness: .regular, topTint: .white, bottomTint: .white)
        .background(.blue)
}
