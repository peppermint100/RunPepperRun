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
    static let standardDistanceForPaceMeters: Double = 100
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
    
    // meter
    var distance: CLLocationDistance {
        return locations.reduce(0.0) { (totalDistance, location) in
            if
                let idx = locations.firstIndex(of: location),
                locations.index(before: idx) > 0 {
                let beforeLocation = locations[locations.index(before: idx)]
                return totalDistance + beforeLocation.distance(from: location)
            }
            else {
                return totalDistance
            }
        }
    }
    
    // km/h
    var speed: CLLocationSpeed {
        if Route.standardDistanceForPaceMeters > distance {
            return 0.0
        }
        return distance.toKiloMeters() / time.toHours()
    }
    
    // seconds
    var time: Double {
        return lastLocation.timestamp.timeIntervalSince(firstLocation.timestamp)
    }
    
    // 칼로리 계산 = MET * 3.5 * WEIGHT(kg) * time(minutes)/ 200
    var caloriesBurned: Double {
        if Route.standardDistanceForPaceMeters > distance {
            return 0.0
        }
        
        return Route.userWeightKilogram * 3.5 * time.toMinutes() * (speed - 3) / 200
    }
    
    var pace: Double {
        if Route.standardDistanceForPaceMeters > distance || paces.isEmpty {
            return 0.0
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
    
    init() {
        self.locations = Array<CLLocation>()
    }
    
    mutating func addLocation(_ location: CLLocation) {
        self.locations.append(location)
    }
    
    // 이 후에 timer 런닝거리경과를 보고 있다가 paces에 pace를 추가한다.
    mutating func addPace() {
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
