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
    
    init(startFrom initiaLocation: CLLocation) {
        self.initialLocation = initiaLocation
        self.activity = RunningActivity(currentLocation: initiaLocation)
        self.location = RunningLocation()
        self.location?.delegate = self
    }

    func stop() {
        location?.stopUpdating()
    }
    
    func start() {
        location?.startUpdating()
    }
}

extension Running: RunningLocationDelegate {
    func didUpdateLocations(_ location: CLLocation) {
        activity?.location = location
    }
}
