//
//  Activity.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/22/23.
//

import Foundation
import MapKit

protocol RunningActivityDelegate: AnyObject {
    func didUpdateDistance(_ distance: CLLocationDistance)
    func didUpdateSpeed(_ speed: CLLocationSpeed)
}

class RunningActivity {
    var delegate: RunningActivityDelegate?
    
    private var currentLocation: CLLocation
    private var startAt: Date
    
    var location: CLLocation {
        willSet {
            distance += newValue.distance(from: currentLocation)
            speed = distance / (newValue.timestamp.timeIntervalSince(startAt))
            delegate?.didUpdateSpeed(speed)
            delegate?.didUpdateDistance(distance)
            currentLocation = newValue
        }
    }
    
    var speed: CLLocationSpeed = 0
    var distance: CLLocationDistance = 0
    var pace: Double = 0
    var caloriesBurned = 0
    
    init(currentLocation: CLLocation) {
        self.currentLocation = currentLocation
        self.location = currentLocation
        self.startAt = currentLocation.timestamp
    }
}
