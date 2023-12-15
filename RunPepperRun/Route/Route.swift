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
    
    private var firstLocation: CLLocation {
        locations.first ?? CLLocation(latitude: 0, longitude: 0)
    }
    
    private var lastLocation: CLLocation {
        locations.last ?? firstLocation
    }
    
    var distance: CLLocationDistance {
        return calculateDistance(locations: self.locations)
    }
    
    var averageSpeed: CLLocationSpeed {
        guard let firstLocation = locations.first, let lastLocation = locations.last else {
            return 0.0
        }

        let timeInterval = lastLocation.timestamp.timeIntervalSince(firstLocation.timestamp)
        let totalDistance = calculateDistance(locations: locations)
        return totalDistance / timeInterval
    }
    
    var pace: TimeInterval {
        return calculateTotalTimeSeconds(locations: self.locations) / distance / 1000
    }
    
    // 칼로리 = MET x 체중(kg) x 시간(시간)
    var caloriesBurned: Double {
        return met * Route.userWeightKilogram * ((lastLocation.timestamp.timeIntervalSince(firstLocation.timestamp))/3600)
    }
    
    // MET = (1.11 x 속도(km/h))^2 + 3.09
    private var met: Double {
        return pow(1.11, averageSpeed) + 3.09
    }
    
    init() {
        self.locations = Array<CLLocation>()
    }
    
    mutating func addLocation(_ location: CLLocation) {
        self.locations.append(location)
    }
    
    private func calculateDistance(locations: [CLLocation]) -> CLLocationDistance {
        return locations.reduce(0.0) { (totalDistance, location) in
            let nextLocation = locations[locations.index(after: locations.firstIndex(of: location) ?? 0)]
            return totalDistance + nextLocation.distance(from: location)
        }
    }
    
    func calculateTotalTimeSeconds(locations: [CLLocation]) -> TimeInterval {
        guard let firstLocation = locations.first, let lastLocation = locations.last else {
            return 0.0
        }

        let totalTime = lastLocation.timestamp.timeIntervalSince(firstLocation.timestamp)
        return totalTime
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
