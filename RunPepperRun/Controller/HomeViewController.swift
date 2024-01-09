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
    
    private let mapViewTag = "mapViewTag"
    
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
        view.addSubview(stackView)
        view.backgroundColor = .systemBackground
        setupStackView()
        setupNavigationBar()
        setupMapView()
        setupActivities()
        setupActivityCollectionView()
        setupButtonView()
        setupStartButton()
        setupLocationManager()
        handleLocationAuthorization()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        drawGradientOnMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        drawGradientOnMap()
    }
    
    // MARK: - 네비게이션 바 세팅
    private func setupNavigationBar() {
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // TODO: - Setting Feature에서 추가 개발
    private func getRunningActivitiesForHomeVC() -> [RunningActivity] {
        let activities: [RunningActivity] = [.speed(36), .cadence(10), .caloriesBurned(224)]
        return activities
    }
    
    // MARK: - UI 세팅
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func setupMapView() {
        stackView.addArrangedSubview(mapView)
        mapView.userTrackingMode = .follow
        mapView.showsUserLocation = true
        mapView.layer.cornerRadius = 10
        mapView.clipsToBounds = true
        mapView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).offset(-10).multipliedBy(0.6)
            make.leading.trailing.top.equalToSuperview()
        }
    }
    
    private func setupActivities() {
        activities = getRunningActivitiesForHomeVC()
    }
    
    private func setupActivityCollectionView() {
        stackView.addArrangedSubview(activityCollectionView)
        activityCollectionView.register(ActivityCardCell.self, forCellWithReuseIdentifier: ActivityCardCell.identifier)
        activityCollectionView.delegate = self
        activityCollectionView.dataSource = self
        activityCollectionView.showsHorizontalScrollIndicator = false
        
        activityCollectionView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).offset(-10).multipliedBy(0.28)
        }
    }
    
    private func setupButtonView() {
        stackView.addArrangedSubview(buttonView)
        buttonView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).multipliedBy(0.12)
        }
    }
    
    private func setupStartButton() {
        buttonView.addSubview(startButton)
        startButton.setTitle("러닝 시작하기", for: .normal)
        startButton.setTitleColor(.label, for: .normal)
        startButton.backgroundColor = .secondarySystemBackground
        startButton.layer.cornerRadius = 10
        startButton.clipsToBounds = true
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        startButton.addTarget(self, action: #selector(presentToRunningVC), for: .touchUpInside)
        
        startButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    private func drawGradientOnMap() {
        if traitCollection.userInterfaceStyle == .light {
            mapView.drawLightGradientOnTop(tag: mapViewTag)
        } else {
            mapView.layer.sublayers?.forEach({ layer in
                if layer.name == mapViewTag {
                    layer.removeFromSuperlayer()
                }
            })
        }
    }
    
    @objc private func presentToRunningVC() {
        let vc = RunningViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - 맵, 위치
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
