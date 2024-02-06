//
//  RunningViewController.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/7/23.
//

import UIKit
import MapKit
import SnapKit
import CoreMotion
import FirebaseAuth

class HomeViewController: UIViewController {
    
    private let mapViewTag = "mapViewTag"
    
    private let locationManager = CLLocationManager()
    
    private var runningStats: [RunningStat] = []
    
    private let stackView = UIStackView()
    private let mapView = MKMapView()
    private var runningStatCollectionView: UICollectionView = {
        let layout = RunningStatCollectionViewLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        setupRunningStats()
        setupRunningStatCollectionView()
        setupButtonView()
        setupStartButton()
        handleLocationAuthorization()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        drawGradientOnMap()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        drawGradientOnMap()
    }
    
    // MARK: - 네비게이션 바 세팅
    private func setupNavigationBar() {
        navigationItem.title = "Home"
        navigationController?.navigationBar.sizeToFit()
        navigationController?.navigationBar.prefersLargeTitles = true
        let buttonSize = CGSize(width: 25, height: 25)
        let chartIcon = UIImage(systemName: "chart.bar")!.withTintColor(.inverted).resizeImage(targetSize: buttonSize)
        let gearIcon = UIImage(systemName: "gearshape")!.withTintColor(.inverted).resizeImage(targetSize: buttonSize)
        let toHistoryVCButton = UIButton()
        let toSettingVCButton =  UIButton()
        toHistoryVCButton.setImage(chartIcon, for: .normal)
        toHistoryVCButton.addTarget(self, action: #selector(presentToHistoryVC), for: .touchUpInside)
        toSettingVCButton.setImage(gearIcon, for: .normal)
        toSettingVCButton.addTarget(self, action: #selector(presentToSettingVC), for: .touchUpInside)
        let toHistoryBarButton = UIBarButtonItem(customView: toHistoryVCButton)
        let toSettingBarButton = UIBarButtonItem(customView: toSettingVCButton)
        navigationItem.rightBarButtonItems = [toSettingBarButton, toHistoryBarButton]
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
    
    private func setupRunningStats() {
        let now = Date()
        let aWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        HistoryManager.shared.getHistories(from: aWeekAgo, to: now) { [weak self] result in
            switch result {
            case .success(let histories):
                var speed: Double = 0
                var numberOfSteps: Int = 0
                var caloriesBurned: Double = 0
                histories.forEach { history in
                    speed += history.averageSpeed
                    numberOfSteps += history.numberOfSteps
                    caloriesBurned += history.caloriesBurned
                }
                self?.runningStats = [.speed(speed), .numberOfSteps(numberOfSteps), .caloriesBurned(caloriesBurned)]
                DispatchQueue.main.async {
                    self?.runningStatCollectionView.reloadData()
                }
            case .failure:
                NSLog("HomeVC에서 최근 러닝 기록을 불러오는데 실패했습니다.")
                return
            }
        }
    }
    
    private func setupRunningStatCollectionView() {
        stackView.addArrangedSubview(runningStatCollectionView)
        runningStatCollectionView.register(RunningStatCardCell.self, forCellWithReuseIdentifier: RunningStatCardCell.identifier)
        runningStatCollectionView.delegate = self
        runningStatCollectionView.dataSource = self
        runningStatCollectionView.showsHorizontalScrollIndicator = false
        
        runningStatCollectionView.snp.makeConstraints { make in
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
        startButton.addTarget(self, action: #selector(didTapStartRunningButton), for: .touchUpInside)
        
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
    
    @objc private func didTapStartRunningButton() {
        if hasAuthorizationsForRunning() {
            presentToRunningVC()
        } else {
            makeOpenSettingsAlert()
        }
    }
    
    private func hasAuthorizationsForRunning() -> Bool {
        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            return false
        default:
            break
        }
        
        switch CMMotionActivityManager.authorizationStatus() {
        case .notDetermined, .restricted, .denied:
            return false
        default:
            break
        }
        
        switch CMPedometer.authorizationStatus() {
        case .notDetermined, .restricted, .denied:
            return false
        default:
            break
        }
        
        return true
    }
    
    private func presentToRunningVC() {
        let vc = RunningViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func presentToHistoryVC() {
        let vc = HistoryViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func presentToSettingVC() {
        let vc = SettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func makeOpenSettingsAlert() {
        let vc = UIAlertController(title: "권한 미허용", message: "러닝 루트 기록을 위해 위치, 동작 권한을 허용해주세요", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let openSettings = UIAlertAction(title: "설정", style: .default) { openSettingsAction in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        vc.addAction(cancel)
        vc.addAction(openSettings)
        present(vc, animated: true)
    }
}

// MARK: - 맵, 위치
extension HomeViewController {
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
        return runningStats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RunningStatCardCell.identifier, for: indexPath) as! RunningStatCardCell
        let stat = runningStats[indexPath.row]
        cell.configure(with: stat)
        return cell
    }
}
