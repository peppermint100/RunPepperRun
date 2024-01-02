//
//  RunningViewController.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/7/23.
//

import UIKit
import MapKit
import SnapKit

class HomeViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    private let mapView: MKMapView = {
        let mv = MKMapView()
        mv.userTrackingMode = .follow
        mv.showsUserLocation = true
        mv.layer.cornerRadius = 10
        mv.clipsToBounds = true
        return mv
    }()
    
    private let activitySummerizeView: UIStackView = {
        let sv = UIStackView()
        return sv
    }()
    
    private let buttonView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("러닝 시작하기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return button
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
        navigationItem.title = "0 km"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
// MARK: - UI 세팅
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        stackView.addArrangedSubview(mapView)
        stackView.addArrangedSubview(activitySummerizeView)
        stackView.addArrangedSubview(buttonView)
        buttonView.addSubview(startButton)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle == .light {
            let gradientLayer = CAGradientLayer()
            var colors: [CGColor] = []
            colors.append(UIColor.white.withAlphaComponent(1).cgColor)
            colors.append(UIColor.white.withAlphaComponent(0).cgColor)
            gradientLayer.colors = colors
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.2)
            gradientLayer.frame = stackView.bounds
            gradientLayer.name = "mapViewLayer"
            mapView.layer.addSublayer(gradientLayer)
        } else {
            mapView.layer.sublayers?.forEach({ layer in
                if layer.name == "mapViewLayer" {
                    layer.removeFromSuperlayer()
                }
            })
        }
    }
    
    private func applyConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        mapView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).multipliedBy(0.5)
            make.leading.trailing.top.equalToSuperview()
        }
        
        activitySummerizeView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).multipliedBy(0.3)
        }
        
        buttonView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).multipliedBy(0.2)
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
}

// MARK: - 맵, 위치 관련
extension HomeViewController: CLLocationManagerDelegate, MKMapViewDelegate {
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
