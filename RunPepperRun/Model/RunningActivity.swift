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
    func didUpdatePace(_ pace: NSNumber)
}

class RunningActivity {
    static let weight: Double = 70
    var delegate: RunningActivityDelegate?
    
    private var currentLocation: CLLocation
    private var startAt: Date
    var motion: MotionStatus = .stationary
    
    var location: CLLocation {
        willSet {
            updateDistance(newValue)
            updateSpeed(newValue)
            updateCalories()
            currentLocation = newValue
        }
    }
    
    var pace: NSNumber = 0 {
        didSet {
            updatePace(oldValue)
        }
    }
    
    var paces: [NSNumber] = []
    
    var speed: CLLocationSpeed = 0
    var distance: CLLocationDistance = 0
    var caloriesBurned: Double = 0
    
    init(currentLocation: CLLocation) {
        self.currentLocation = currentLocation
        self.location = currentLocation
        self.startAt = currentLocation.timestamp
    }
    
    private func updateSpeed(_ updatedLocation: CLLocation) {
        speed = distance / (updatedLocation.timestamp.timeIntervalSince(startAt))
        delegate?.didUpdateSpeed(speed)
    }
    
    private func updateDistance(_ updatedLocation: CLLocation) {
        distance += updatedLocation.distance(from: currentLocation)
        delegate?.didUpdateDistance(distance)
    }
    
    private func updateCalories() {
        caloriesBurned += motion.met() * 1.08 * RunningActivity.weight / 3600
        delegate?.didUpdateCaloriesBurned(caloriesBurned)
    }
    
    private func updatePace(_ pace: NSNumber) {
        paces.append(pace)
        delegate?.didUpdatePace(pace)
    }

}
