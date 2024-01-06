//
//  RunningViewController.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/6/24.
//

import UIKit
import MapKit
import SnapKit

class RunningViewController: UIViewController {
    
    private let stackView = UIStackView()
    private let mapView = MKMapView()
    private let activityCollectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: ActivityCellScollLayout())
    }()
    
    private let runningStatusView = UIView()
    private var activities: [RunningActivity] = []
    
    private let timerView = UIStackView()
    private let timerIndicatorView = UIView()
    private var timerIndicatorIcon = UIImageView()
    private let timerIndicatorLabel = UILabel()
    private let timerLabel = UILabel()
    private let distanceLabel = UILabel()
    private let runningStatusButtonView = UIView()
    private let runningStatusButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupStackView()
        setupMapView()
        setupActivities()
        setupActivityView()
        setupRunnginStatusView()
        setupTimerView()
        setUpRunningStatusButton()
    }
    
    private func setupNavigation() {
        navigationItem.title = "Running"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    private func setupMapView() {
        stackView.addArrangedSubview(mapView)
        mapView.userTrackingMode = .follow
        mapView.showsUserLocation = true
        mapView.layer.cornerRadius = 10
        mapView.clipsToBounds = true
        mapView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).offset(-8).multipliedBy(0.6)
        }
    }
    
    private func setupActivities() {
        activities = [.speed(0), .pace(0), .distance(0), .cadence(0), .caloriesBurned(0)]
    }
    
    private func setupActivityView() {
        stackView.addArrangedSubview(activityCollectionView)
        activityCollectionView.register(ActivityCardCell.self, forCellWithReuseIdentifier: ActivityCardCell.identifier)
        activityCollectionView.delegate = self
        activityCollectionView.dataSource = self
        activityCollectionView.showsHorizontalScrollIndicator = false
        activityCollectionView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).multipliedBy(0.2)
        }
    }
    
    private func setupRunnginStatusView() {
        stackView.addArrangedSubview(runningStatusView)
        runningStatusView.backgroundColor = .secondarySystemBackground
        runningStatusView.layer.cornerRadius = 10
        runningStatusView.clipsToBounds = true
        runningStatusView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).offset(-8).multipliedBy(0.2)
        }
    }
    
    private func setupTimerView() {
        runningStatusView.addSubview(timerView)
        timerView.axis = .vertical
        timerView.distribution = .fillEqually
        
        timerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
        setupTimerIndicatorView()
        setupTimerLabel()
        setupDistanceLabel()
    }
    
    private func setupTimerIndicatorView() {
        timerView.addArrangedSubview(timerIndicatorView)
        timerIndicatorView.addSubview(timerIndicatorIcon)
        timerIndicatorView.addSubview(timerIndicatorLabel)
        setupTimerIndicatorIcon()
        setupTimerIndicatorLabel()
    }
    
    private func setupTimerIndicatorIcon() {
        let image = UIImage(systemName: "stopwatch")!
        timerIndicatorIcon.tintColor = .systemGray
        timerIndicatorIcon.image = image
        timerIndicatorIcon.contentMode = .scaleAspectFit
        timerIndicatorIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.2)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupTimerIndicatorLabel() {
        timerIndicatorLabel.text = "Time"
        timerIndicatorLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        timerIndicatorLabel.textColor = .systemGray
        timerIndicatorLabel.snp.makeConstraints { make in
            make.leading.equalTo(timerIndicatorIcon.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
    }
    private func setupTimerLabel() {
        timerView.addArrangedSubview(timerLabel)
        timerLabel.text = "00:00:00"
        timerLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        timerLabel.textColor = .label
    }
    
    private func setupDistanceLabel(){
        timerView.addArrangedSubview(distanceLabel)
        distanceLabel.text = "2.5km"
        distanceLabel.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        distanceLabel.textColor = .systemGray
    }
    
    private func setUpRunningStatusButton() {
        runningStatusView.addSubview(runningStatusButton)
        let buttonSize: CGFloat = 80
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        runningStatusButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: imageConfig)!, for: .normal)
        runningStatusButton.layer.cornerRadius = buttonSize / 2
        runningStatusButton.clipsToBounds = true
        runningStatusButton.backgroundColor = .black
        runningStatusButton.tintColor = .white
        runningStatusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(buttonSize)
            make.height.equalTo(buttonSize)
        }
    }
}

extension RunningViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
