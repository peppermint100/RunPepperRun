//
//  Running.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/22/23.
//

import Foundation
import MapKit


class Running {
    
    var initialLocation: CLLocation
    var location: RunningLocation?
    var activity: RunningActivity?
    var motion: RunningMotion?
    
    init(startFrom initiaLocation: CLLocation) {
        self.initialLocation = initiaLocation
        self.activity = RunningActivity(currentLocation: initiaLocation)
        self.location = RunningLocation()
        self.motion = RunningMotion()
        self.location?.delegate = self
        self.motion?.delegate = self
    }

    func pause() {
        location?.stopUpdating()
    }
    
    func start() {
        location?.startUpdating()
    }
    
    func finish() {
        motion?.stopObservingMotion()
    }
}

extension Running: RunningLocationDelegate {
    func didUpdateLocations(_ location: CLLocation) {
        activity?.location = location
    }
}

extension Running: RunningMotionDelegate {
    func didUpdatePace(_ pace: NSNumber) {
        activity?.pace = pace
    }
    
    func didChangeMotionStatus(_ motion: MotionStatus) {
        activity?.motion = motion
    }
}

