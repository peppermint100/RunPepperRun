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
        return sv
    }()
    
    private let runningCardView: UICollectionView = {
        let layout = RunningCardCollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let runningMapView: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.userTrackingMode = .follow
        return mv
    }()
    
    private let startButton: RoundedButton = {
        let button = RoundedButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        buildNavigationBar()
        buildCollectionView()
        applyConstraints()
        setUpLocationManager()
        handleLocationAuthorization()
    }
    
// MARK: - 네비게이션 바 세팅
    private func buildNavigationBar() {
        navigationItem.title = "러닝"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
// MARK: - UI 세팅
    private func buildUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        view.addSubview(startButton)
        stackView.addArrangedSubview(runningCardView)
        stackView.addArrangedSubview(runningMapView)
        startButton.delegate = self
    }
    
    private func buildCollectionView() {
        runningCardView.delegate = self
        runningCardView.dataSource = self
        runningCardView.register(RunningCardCollectionViewCell.self, forCellWithReuseIdentifier: RunningCardCollectionViewCell.identifier)
    }
    
//MARK: - 제약조건
    private func applyConstraints() {
        let stackViewConstraints = [
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        let runningHistoryViewConstraints = [
            runningCardView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.35)
        ]
        
        let runningMapViewConstraints = [
            runningMapView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.65)
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
extension RunningViewController: CLLocationManagerDelegate, MKMapViewDelegate {
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

// MARK: - 시작 버튼 델리게이트
extension RunningViewController: RoundedButtonDelegate {
    func didTapButton() {
    }
}
