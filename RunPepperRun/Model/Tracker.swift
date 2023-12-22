//
//  Tracker.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/20/23.
//

import Foundation
import MapKit

protocol TrackerDelegate: AnyObject {
    func tracker(_ tracker: Tracker, updateSpeed: String)
    func tracker(_ tracker: Tracker, updateDistance: String)
}

class Tracker: NSObject {
    var initialLocation: CLLocation
    
    weak var delegate: TrackerDelegate?
    
    private var locations = [CLLocation]()
    var coordinates: [CLLocationCoordinate2D] {
        get {
            return locations.map { $0.coordinate }
        }
    }
    private let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation {
        locations.last ?? initialLocation
    }
    
    // m/s
    var speed: CLLocationSpeed {
        return currentLocation.speed > 0
        ? currentLocation.speed 
        : distance / currentLocation.timestamp.timeIntervalSince(initialLocation.timestamp)
    }
    
    // meters
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
    
    func updateLocation(_ location: CLLocation) {
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
            updateLocation(location)
            let speed = String(format: "%.2f km/h", speed.toKilometersPerHour())
            let distance = String(format: "%.2f km", distance.toKiloMeters())
            delegate?.tracker(self, updateDistance: distance)
            delegate?.tracker(self, updateSpeed: speed)
        }
    }
}
