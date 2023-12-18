//
//  Route.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/10/23.
//

import Foundation
import MapKit


struct Route {
    // TODO: - 이 후에 UserDefaults로 사용자가 설정할 수 있도록 지정
    // 단위는 CLLocationDistance와 일치하도록 meter
    static let standardDistanceForPaceMeters = 500
    static let userWeightKilogram: Double = 70
    
    private var locations: [CLLocation]
    private var coordinates: [CLLocationCoordinate2D] {
        get {
            return locations.map { $0.coordinate }
        }
    }
    
    var firstLocation: CLLocation {
        locations.first ?? CLLocation(latitude: 0, longitude: 0)
    }
    
    var lastLocation: CLLocation {
        locations.last ?? firstLocation
    }
    
    // km
    var distance: CLLocationDistance {
        return locations.reduce(0.0) { (totalDistance, location) in
            let nextLocation = locations[locations.index(after: locations.firstIndex(of: location) ?? 0)]
            return totalDistance + nextLocation.distance(from: location)
        }.toKiloMeters()
    }
    
    // km/h
    var speed: CLLocationSpeed {
        return distance / time
    }
    
    // hours
    var time: Double {
        return lastLocation.timestamp.timeIntervalSince(firstLocation.timestamp).toHours()
    }
    
    // 칼로리 = MET x 체중(kg) x 시간(시간)
    var caloriesBurned: Double {
        return met * Route.userWeightKilogram * time
    }
    
    var pace: Double {
        if paces.isEmpty {
            let weight = 1 / distance
            return time * weight
        }
        
        return paces.last!
    }
    
    private var paces: [Double] = []
    
    var averagePaces: Double {
        if paces.isEmpty {
            return pace
        }
        
        return paces.reduce(0.0, +) / Double(paces.count)
    }
    
    // MET = (1.11 x 속도(km/h))^2 + 3.09
    private var met: Double {
        return pow(1.11 * speed, 2) + 3.09
    }
    
    init() {
        self.locations = Array<CLLocation>()
    }
    
    mutating func addLocation(_ location: CLLocation) {
        self.locations.append(location)
    }
    
    mutating func savePace() {
        paces.append(pace)
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
