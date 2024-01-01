//
//  RunningViewController.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/7/23.
//

import UIKit
import MapKit
import SnapKit

class RunningViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    
    private let mapView: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.userTrackingMode = .follow
        mv.showsUserLocation = true
        return mv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        applyConstraints()
        setupNavigationBar()
        setupLocationManager()
        handleLocationAuthorization()
    }
    
// MARK: - 네비게이션 바 세팅
    private func setupNavigationBar() {
        navigationItem.title = "러닝"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
// MARK: - UI 세팅
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(mapView)
    }

}

// MARK: - 맵, 위치 관련
extension RunningViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    private func setupLocationManager() {
        locationManager.delegate = self
    }
    
    private func handleLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
        
        switch locationManager.accuracyAuthorization {
        case .reducedAccuracy:
            locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "Allow Full Accuracy")
        default:
            break
        }
    }
}
