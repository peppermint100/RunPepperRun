//
//  RunningLocation.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/22/23.
//

import Foundation
import MapKit

protocol RunningLocationDelegate {
    func didUpdateLocations(_ location: CLLocation)
}

class RunningLocation: NSObject, CLLocationManagerDelegate {
    
    var delegate: RunningLocationDelegate?
    
    private let manager = CLLocationManager()
    var locations: [CLLocation] = []
    
    var coordinates: [CLLocationCoordinate2D] {
        locations.map { $0.coordinate }
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
            delegate?.didUpdateLocations(location)
        }
    }
}
