//
//  LL2Model.swift
//  T Minus
//
//  Created by Dylan Hawley on 10/30/23.
//

import Foundation


struct Launch: Decodable {
    let id: String
    let name: String
    let status: LaunchStatus
    let last_updated: String
    let net: String
    let window_end: String
    let window_start: String
    let net_precision: NetPrecision
    let holdreason: String
    let failreason: String
    let rocket: Rocket
    let mission: Mission
    let pad: Pad
    let image: String
    
    struct LaunchStatus: Decodable {
        let name: String
        let abbrev: String
        let description: String
    }
    
    struct NetPrecision: Decodable {
        let name: String
        let abbrev: String
        let description: String
    }
    
    struct Rocket: Decodable {
        let configuration: RocketConfiguration
        
        struct RocketConfiguration: Decodable {
            let url: String
            let name: String
            let family: String
            let full_name: String
            let variant: String
        }
    }
    
    struct Mission: Decodable {
        let name: String
        let description: String
        let type: String
        let orbit: Orbit
        
        struct Orbit: Decodable {
            let name: String
            let abbrev: String
        }
    }

    struct Pad: Decodable {
        let name: String
        let map_url: String?
        let latitude: String
        let longitude: String
        let location: Location
        
        struct Location: Decodable {
            let name: String
            let country_code: String
            let timezone_name: String
        }
    }
}

struct LL2Response: Decodable {
    let results: [Launch]
}
