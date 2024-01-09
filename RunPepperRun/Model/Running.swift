//
//  Running.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/8/24.
//

import Foundation

protocol RunningDelegate {
    func didUpdateRunningActivity(_ running: Running, distance: Double, speed: Double, pace: Double, caloriesBurned: Double, numberOfSteps: Int)
}

class Running: MotionDelegate {
    private let startDate = Date()
    private var location: Location?
    private var motion: Motion?
    
    private var speed: Double = 0
    private var distance: Double = 0
    private var numberOfSteps = 0
    private var caloriesBurned: Double = 0
    private var pace: Double = 0
    
    private var averagePace: Double = 0
    
    private var speedArray: [Double] = []
    
    private let caloriesCalculator = CaloriesCalculator()
    
    var delegate: RunningDelegate?
    
    init() {
        location = Location()
        motion = Motion(startDate: startDate)
        motion?.delegate = self
    }
    
    func start() {
        location?.startUpdating()
        motion?.startUpdating()
    }
    
    func pause() {
        location?.stopUpdating()
        motion?.stopUpdating()
    }
    
    func getResults() -> RunningResult {
        let averageSpeed = speedArray.reduce(0.0, +) / Double(speedArray.count)
        return RunningResult(points: location?.pointsCompacted() ?? [], distance: self.distance, duration: self.distance, averageSpeed: averageSpeed, averagePace: self.averagePace, caloriesBurend: self.caloriesBurned, numberOfSteps: self.numberOfSteps)
    }
    
    func didUpdateMotion(_ motion: Motion?, distance: Double?, pace: Double?, averagePace: Double?, motionActivity: MotionActivity, numberOfSteps: Int?, lastUpdatedAt: Date?) {
        let now = Date()
        self.distance = distance ?? self.distance
        self.pace = pace ?? self.pace
        self.numberOfSteps = numberOfSteps ?? self.numberOfSteps
        self.averagePace = averagePace ?? self.averagePace
        self.speed = self.distance / now.timeIntervalSince(startDate)
        speedArray.append(self.speed)
        self.caloriesBurned += caloriesCalculator.getCalories(speed: speed, duration: now.timeIntervalSince(lastUpdatedAt ?? now), motionActivity: motionActivity)
        delegate?.didUpdateRunningActivity(self, distance: self.distance, speed: self.speed, pace: self.pace, caloriesBurned: self.caloriesBurned, numberOfSteps: self.numberOfSteps)
    }
}

