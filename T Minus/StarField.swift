//
//  StarField.swift
//  T Minus
//
//  Created by Dylan Hawley on 10/27/24.
//

import Foundation

class StarField {
    var stars = [Star]()
    let leftEdge = -50.0
    let rightEdge = 500.0
    var lastUpdate = Date.now

    init() {
        for _ in 1...200 {
            let x = Double.random(in: leftEdge...rightEdge)
            let y = Double.random(in: 0...600)
            let size = Double.random(in: 1...3)
            let star = Star(x: x, y: y, size: size)
            stars.append(star)
        }
    }

    func update(date: Date) {
        let delta = min(date.timeIntervalSince1970 - lastUpdate.timeIntervalSince1970, 0.1)

        for star in stars {
            star.x -= delta * 2
            
            if star.x < leftEdge {
                star.x = rightEdge
            }
        }

        lastUpdate = date
    }
}
