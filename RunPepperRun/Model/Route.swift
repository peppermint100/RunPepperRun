//
//  Route.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/10/23.
//

import Foundation
import MapKit


struct Route {
    private var locations: [CLLocation]
    private var coordinates: [CLLocationCoordinate2D] {
        get {
            return locations.map { $0.coordinate }
        }
    }
    
    init() {
        self.locations = Array<CLLocation>()
    }
    
    mutating func addLocation(_ location: CLLocation) {
        self.locations.append(location)
    }
}

extension Route: RouteDisplaying {
    func drawRouteOn(map: MKMapView) {
        let count = locations.count
        
        DispatchQueue.main.async {
            let line = MKPolyline(coordinates: coordinates, count: count)
            map.addOverlay(line, level: .aboveRoads)
            let customEdgePadding: UIEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 20)
            map.setVisibleMapRect(line.boundingMapRect, edgePadding: customEdgePadding, animated: false)
        }
    }
}
