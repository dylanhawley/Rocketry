//
//  LaunchDetailed.swift
//  Rocketry
//
//  Created by Dylan Hawley on 12/5/24.
//

import Foundation

struct LaunchDetailed: Decodable {
//    let updates: [Update]
//    let rocket: Rocket
    let vidURLs: [VidURL]
//    let timeline: TimelineItem
    
    struct Update: Decodable {
        let profile_image: String
        let comment: String
        let info_url: String
        let created_by: String
        let created_on: Date
    }
    
    struct Rocket: Decodable {
        let launcher_stage: LauncherStage
        
        struct LauncherStage: Decodable {
            let landing: Landing
            
            struct Landing: Decodable {
                let attempt: Bool
                let success: Bool
                let location: Location
                
                struct Location: Decodable {
                    let name: String
                    let abbrev: String
                    let description: String
                }
            }
        }
    }
    
    struct VidURL: Decodable {
        let priority: Int
        let publisher: String
        let title: String
        let description: String
        let feature_image: String
        let url: String
    }
    
    struct TimelineItem: Decodable {
        let type: TypeItem
        let relative_time: String
        
        struct TypeItem: Decodable {
            let id: Int
            let abbrev: String
            let description: String
        }
    }
}
