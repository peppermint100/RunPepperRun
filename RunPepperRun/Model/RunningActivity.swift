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
    func didUpdateCaloriesBurned(_ caloriesBurned: Double)
}

class RunningActivity {
    static let weight: Double = 70
    var delegate: RunningActivityDelegate?
    
    private var currentLocation: CLLocation
    private var startAt: Date
    var motion: MotionStatus = .stationary
    
    var location: CLLocation {
        willSet {
            distance += newValue.distance(from: currentLocation)
            speed = distance / (newValue.timestamp.timeIntervalSince(startAt))
            caloriesBurned += motion.met() * 1.08 * RunningActivity.weight / 3600
            delegate?.didUpdateSpeed(speed)
            delegate?.didUpdateDistance(distance)
            delegate?.didUpdateCaloriesBurned(caloriesBurned)
            currentLocation = newValue
        }
    }
    
    var speed: CLLocationSpeed = 0
    var distance: CLLocationDistance = 0
    var pace: Double = 0
    var caloriesBurned: Double = 0
    
    init(currentLocation: CLLocation) {
        self.currentLocation = currentLocation
        self.location = currentLocation
        self.startAt = currentLocation.timestamp
    }
}
