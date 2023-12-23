//
//  RunningMotion.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/23/23.
//

import Foundation
import CoreMotion

protocol RunningMotionDelegate {
    func didChangeMotionStatus(_ motion: MotionStatus)
    func didUpdatePace(_ pace: NSNumber)
}

class RunningMotion {
    
    var delegate: RunningMotionDelegate?
    private let activityManager = CMMotionActivityManager()
    private let pedometerManager = CMPedometer()
    
    var paces: [NSNumber] = []
    
    init() {
        observeMotion()
        observePedometer()
    }
    
    private func observePedometer() {
        pedometerManager.startUpdates(from: Date()) { [weak self] data, error in
            guard error == nil, let data = data else {
                return
            }
            
            if let pace = data.currentPace {
                self?.paces.append(pace)
                
                DispatchQueue.main.async {
                    self?.delegate?.didUpdatePace(pace)
                }
            }
        }
    }
    
    private func observeMotion() {
        activityManager.startActivityUpdates(to: .main) { [weak self] activity in
            if let activity = activity {
                if activity.stationary {
                    self?.delegate?.didChangeMotionStatus(.stationary)
                } else if activity.walking {
                    self?.delegate?.didChangeMotionStatus(.walking)
                } else if activity.running {
                    self?.delegate?.didChangeMotionStatus(.running)
                }
            }
        }
    }
    
    func stopObservingMotion() {
        activityManager.stopActivityUpdates()
    }
}
