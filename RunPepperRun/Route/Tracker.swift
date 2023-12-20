//
//  Tracker.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/20/23.
//

import Foundation
import MapKit

class Tracker: NSObject {
    var initialLocation: CLLocation
    
    private var locations = [CLLocation]()
    private var coordinates: [CLLocationCoordinate2D] {
        get {
            return locations.map { $0.coordinate }
        }
    }
    private let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation {
        locations.last ?? initialLocation
    }
    
    var speed: CLLocationSpeed {
        currentLocation.speed
    }
    
    var distance: CLLocationDistance = 0.0
    
    // TODO: - HealthKit 연동
    var caloriesBurned: Double = 0.0
    
    // TODO: - PACE 계산기능 추가
    var pace: Double = 0.0
    
    init(initialLocation: CLLocation) {
        self.initialLocation = initialLocation
        locations.append(initialLocation)
        super.init()
        setUpLocationManager()
    }
    
    func addLocation(_ location: CLLocation) {
        distance += currentLocation.distance(from: location)
        locations.append(location)
    }
}

// MARK: - LocationManager
extension Tracker: CLLocationManagerDelegate {
    
    private func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            addLocation(location)
        }
    }
}

// MARK: - Route
extension Tracker: RouteDisplaying {
    func drawRouteOn(map: MKMapView) {
        let count = locations.count
        let line = MKPolyline(coordinates: coordinates, count: count)
        
        DispatchQueue.main.async {
            map.addOverlay(line, level: .aboveRoads)
            let customEdgePadding: UIEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 20)
            map.setVisibleMapRect(line.boundingMapRect, edgePadding: customEdgePadding, animated: false)
        }
    }
}
