//
//  Coordinate.swift
//  Stormy
//
//  Created by Arshin Jain on 9/28/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

struct Coordinate {
    let latitude:   Double
    let longitude:  Double
    
    /*
    init(latitude: Double, longitude: Double) {
        self.latitude  = latitude
        self.longitude = longitude
    }
     */
}

extension Coordinate: CustomStringConvertible {
    
    var description: String {
        return "\(latitude),\(longitude)"
    }
    
    static var alcatrazIsland: Coordinate {
        let vc = ViewController()
        let coordinates = vc.getCoordinates()
        return Coordinate(latitude: coordinates[0], longitude: coordinates[0])
    }
    
}
