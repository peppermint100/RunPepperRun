//
//  RunningViewController.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/7/23.
//

import UIKit
import MapKit


class RunningViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        return sv
    }()
    
    private let runningCardView: UICollectionView = {
        let layout = RunningCardCollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let runningMapView: DrawableMapView = {
        let mv = DrawableMapView()
        mv.userTrackingMode = .follow
        mv.translatesAutoresizingMaskIntoConstraints = false
        return mv
    }()
    
    private let startButton: RoundedButton = {
        let button = RoundedButton("시작", color: .systemBlue, shadow: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpNavigationBar()
        setUpRunningCardCollectionView()
        applyConstraints()
        setUpLocationManager()
        setUpStartButton()
        handleLocationAuthorization()
    }
    
// MARK: - 네비게이션 바 세팅
    private func setUpNavigationBar() {
        navigationItem.title = "러닝"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
// MARK: - UI 세팅
    private func setUpUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        view.addSubview(startButton)
        stackView.addArrangedSubview(runningCardView)
        stackView.addArrangedSubview(runningMapView)
    }
    
    private func setUpRunningCardCollectionView() {
        runningCardView.delegate = self
        runningCardView.dataSource = self
        runningCardView.register(RunningCardCollectionViewCell.self, forCellWithReuseIdentifier: RunningCardCollectionViewCell.identifier)
    }
    
//MARK: - 제약조건
    private func applyConstraints() {
        let stackViewConstraints = [
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        let runningHistoryViewConstraints = [
            runningCardView.heightAnchor.constraint(lessThanOrEqualTo: stackView.heightAnchor, multiplier: 0.35)
        ]
        
        let runningMapViewConstraints = [
            runningMapView.heightAnchor.constraint(lessThanOrEqualTo: stackView.heightAnchor, multiplier: 0.65)
        ]
        
        let startButtonConstraints = [
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: runningMapView.bottomAnchor, constant: -30),
            startButton.widthAnchor.constraint(equalTo: runningMapView.widthAnchor, multiplier: 0.3),
            startButton.heightAnchor.constraint(equalTo: runningMapView.widthAnchor, multiplier: 0.3),
        ]
        
        NSLayoutConstraint.activate(stackViewConstraints)
        NSLayoutConstraint.activate(runningHistoryViewConstraints)
        NSLayoutConstraint.activate(runningMapViewConstraints)
        NSLayoutConstraint.activate(startButtonConstraints)
    }
}

// MARK: - 컬렉션 뷰 델리게이트
extension RunningViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: RunningCardCollectionViewCell.identifier, for: indexPath)
                as? RunningCardCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}

    
// MARK: - 맵, 위치 관련
extension RunningViewController: CLLocationManagerDelegate {
    private func setUpLocationManager() {
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

// MARK: - 시작 버튼 관련
extension RunningViewController {
    private func setUpStartButton() {
        startButton.addTarget(self, action: #selector(tapStartButton), for: .touchUpInside)
    }
    
    @objc private func tapStartButton() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            guard let location = locationManager.location else { return }
            let vc = TrackingViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.tracker = Tracker(initialLocation: location)
            present(vc, animated: false)
        default:
            // TODO: - 권한 재요청 코드 추가
            break
        }
    }
}
