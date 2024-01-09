//
//  Point.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/8/24.
//

import Foundation
import MapKit

struct Point {
    let lat: Double
    let lng: Double
    let timestamp: Date
    
    func toCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
    }
}
