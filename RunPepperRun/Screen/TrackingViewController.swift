//
//  TrackingViewController.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/10/23.
//

import UIKit
import MapKit

class TrackingViewController: UIViewController {
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
    }
    
    private func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
}

extension TrackingViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
        }
    }
}
