//
//  Location.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/8/24.
//

import Foundation
import MapKit

class Location: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    var points: [Point] = []
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = 10
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let coordindate = location.coordinate
            points.append(Point(lat: coordindate.latitude, lng: coordindate.longitude, timestamp: location.timestamp))
        }
    }
    
    func startUpdating() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        locationManager.stopUpdatingLocation()
    }
    
    func pointsCompacted() -> [Point] {
        return points
    }
}

