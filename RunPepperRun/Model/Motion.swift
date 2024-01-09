//
//  Motion.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/8/24.
//

import Foundation
import CoreMotion

protocol MotionDelegate {
    func didUpdateMotion(_ motion: Motion?, distance: Double?, pace: Double?, averagePace: Double?, motionActivity: MotionActivity, numberOfSteps: Int?, lastUpdatedAt: Date?)
}

class Motion {
    private let pedoMeter = CMPedometer()
    private let activityManager = CMMotionActivityManager()
    private var caloriesBurned: Double = 0
    private var averagePace: Double?
    
    var motionActivity: MotionActivity = .stationary
    
    var delegate: MotionDelegate?
    var startDate: Date
    var pedometerLastUpdatedAt: Date?
    
    init(startDate: Date) {
        self.startDate = startDate
    }
    
    func startUpdating() {
        pedoMeter.startUpdates(from: startDate) { [weak self] data, error in
            if error != nil { return }
            guard let data = data else { return }
            self?.delegate?.didUpdateMotion(self,
                distance: data.distance?.doubleValue, pace: data.currentPace?.doubleValue, averagePace: data.averageActivePace?.doubleValue,
                                            motionActivity: self?.motionActivity ?? .stationary, numberOfSteps: data.numberOfSteps.intValue, lastUpdatedAt: self?.pedometerLastUpdatedAt)
            self?.pedometerLastUpdatedAt = data.endDate
        }
        
        activityManager.startActivityUpdates(to: OperationQueue.main) { [weak self] activity in
            if activity?.walking == true {
                self?.motionActivity = .walking
            } else if activity?.running == true {
                self?.motionActivity = .running
            } else {
                self?.motionActivity = .stationary
            }
        }
    }
    
    func stopUpdating() {
        pedoMeter.stopUpdates()
        activityManager.stopActivityUpdates()
    }
    
    func getAveragePace() -> Double {
        return averagePace ?? 0
    }
    
    func getCaloriesBurned() -> Double {
        return caloriesBurned
    }
    
    func getDuration() -> TimeInterval {
        return Date().timeIntervalSince(startDate)
    }
}
