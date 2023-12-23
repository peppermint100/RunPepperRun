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
}

class RunningMotion {
    
    var delegate: RunningMotionDelegate?
    private let activityManager = CMMotionActivityManager()
    
    init() {
        observeMotion()
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
