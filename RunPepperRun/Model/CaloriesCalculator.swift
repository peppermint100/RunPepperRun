//
//  CaloriesCalculator.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/8/24.
//

import Foundation

class CaloriesCalculator {
    
    var weight: Double = 0
    
    init() {
        loadUserWeight()
    }
    
    private func loadUserWeight() {
        weight = 70
    }
    
    // Calories Burned = 11.5 METs x 65 kg x 0.75 hours = 563.625 kcal
    func getCalories(speed: Double, duration: TimeInterval?, motionActivity: MotionActivity?) -> Double {
        guard let motionActivity = motionActivity else { return 0 }
        switch motionActivity {
        case .stationary:
            return 0
        case .walking:
            return 3 * weight * (duration ?? 0) / 3600
        case .running:
            let met = getRunningMET(speed: speed)
            return met * weight * (duration ?? 0) / 3600
        }
    }
    
    /*
     Light jogging (5.0 mph or 8.0 km/h): 6 METs
     Running (6.0 mph or 9.7 km/h): 8 METs
     Running (7.0 mph or 11.3 km/h): 10 METs
     Running (8.0 mph or 12.9 km/h): 11.5 METs
     Running (9.0 mph or 14.5 km/h): 12.8 METs
     */
    private func getRunningMET(speed: Double) -> Double {
        switch speed.mpsToKph() {
        case ..<8:
            return 6
        case ...9.7:
            return 8
        case ...11.3:
            return 10
        case ...12.9:
            return 11.5
        default:
            return 12.8
        }
    }
}
