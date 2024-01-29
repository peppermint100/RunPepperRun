//
//  Point.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/8/24.
//

import Foundation
import MapKit

struct Point: Equatable, Codable {
    let lat: Double
    let lng: Double
    let timestamp: Date
    
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.lat == rhs.lat && lhs.lng == rhs.lng
    }
    
    func toCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
    }
}
