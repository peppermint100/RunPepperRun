//
//  Route.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/10/23.
//

import Foundation
import MapKit

struct Route {
    var locations: [CLLocation]
    
    init() {
        self.locations = Array<CLLocation>()
    }
    
    mutating func addLocation(_ location: CLLocation) {
        self.locations.append(location)
    }
}
