//
//  RunningLocation.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/22/23.
//

import Foundation
import MapKit

class RunningLocation: NSObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    var locations: [CLLocation] = []
    var didUpdateLocations: (() -> Void)?
    
    var coordinates: [CLLocationCoordinate2D] {
        locations.map { $0.coordinate }
    }
    
    var currentLocation: CLLocation? {
        locations.last
    }
    
    override init() {
        super.init()
        setUpLocationManager()
    }
    
    private func setUpLocationManager() {
        manager.delegate = self
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        manager.showsBackgroundLocationIndicator = true
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        manager.stopUpdatingLocation()
    }
    
    func startUpdating() {
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.locations.append(location)
            didUpdateLocations?()
        }
    }
}
