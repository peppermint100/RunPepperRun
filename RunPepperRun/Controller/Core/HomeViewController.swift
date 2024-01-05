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
 
    private var activities: [RunningActivity] = []
    
    private let stackView = UIStackView()
    private let mapView = MKMapView()
    private var activityCollectionView: UICollectionView = {
        let activityCollectionViewLayout = ActivityCellLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: activityCollectionViewLayout)
    }()
    private let buttonView = UIView()
    private let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUpStackView()
        setupNavigationBar()
        setupMapView()
        setupActivities()
        setupActivityCollectionView()
        setupButtonView()
        applyConstraints()
        setupLocationManager()
        handleLocationAuthorization()
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
    
// MARK: - 네비게이션 바 세팅
    private func setupNavigationBar() {
        navigationItem.title = "Home"
    }
    
    // TODO: - Setting Feature에서 추가 개발
    private func getRunningActivitiesForHomeVC() -> [RunningActivity] {
        let activities: [RunningActivity] = [.speed(36), .cadence(10), .caloriesBurned(224)]
        return activities
    }
        
// MARK: - UI 세팅
    private func setupUI() {
        view.addSubview(stackView)
        view.backgroundColor = .systemBackground
        stackView.addArrangedSubview(mapView)
        stackView.addArrangedSubview(activityCollectionView)
        stackView.addArrangedSubview(buttonView)
        buttonView.addSubview(startButton)
    }
    
    private func setUpStackView() {
        stackView.axis = .vertical
        stackView.spacing = 10
    }
    
    private func setupActivities() {
        activities = getRunningActivitiesForHomeVC()
    }

    private func setupActivityCollectionView() {
        activityCollectionView.register(ActivityCardCell.self, forCellWithReuseIdentifier: ActivityCardCell.identifier)
        activityCollectionView.delegate = self
        activityCollectionView.dataSource = self
        activityCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupButtonView() {
        startButton.setTitle("러닝 시작하기", for: .normal)
        startButton.setTitleColor(.label, for: .normal)
        startButton.backgroundColor = .secondarySystemBackground
        startButton.layer.cornerRadius = 10
        startButton.clipsToBounds = true
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    private func applyConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        mapView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).offset(-10).multipliedBy(0.6)
            make.leading.trailing.top.equalToSuperview()
        }
        
        activityCollectionView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).offset(-10).multipliedBy(0.28)
        }
        
        buttonView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).multipliedBy(0.12)
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}

// MARK: - 맵, 위치
extension HomeViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    private func setupMapView() {
        mapView.userTrackingMode = .follow
        mapView.showsUserLocation = true
        mapView.layer.cornerRadius = 10
        mapView.clipsToBounds = true
    }
    
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

// MARK: - CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityCardCell.identifier, for: indexPath) as! ActivityCardCell
        let activity = activities[indexPath.row]
        cell.configure(with: activity)
        return cell
    }
}
