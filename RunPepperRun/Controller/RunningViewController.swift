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
    
    private var timer: DispatchSourceTimer?
    private var timerSuspended = true
    private var timerTicking: Bool {
        return seconds > 0 && !timerSuspended
    }
    private var timerIdle: Bool {
        return timer == nil || (timerSuspended && seconds == 0)
    }
    private var seconds = 0
    private let buttonImageConfig = UIImage.SymbolConfiguration(pointSize: 26)
    
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
    private let buttonSize: CGFloat = 80

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
        setupRunningStatusButton()
        setupTimer()
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
        let image = UIImage(systemName: "stopwatch")
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
    
    private func setupRunningStatusButton() {
        runningStatusView.addSubview(runningStatusButton)
        runningStatusButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: buttonImageConfig)!, for: .normal)
        runningStatusButton.layer.cornerRadius = buttonSize / 2
        runningStatusButton.clipsToBounds = true
        runningStatusButton.backgroundColor = .inverted
        runningStatusButton.tintColor = .systemBackground
        runningStatusButton.addTarget(self, action: #selector(onTapRunningStatusButton), for: .touchUpInside)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressRunningStatusButton(_:)))
        runningStatusButton.addGestureRecognizer(longPressGesture)
        runningStatusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview().offset(-25)
            make.width.equalTo(buttonSize)
            make.height.equalTo(buttonSize)
        }
    }
    
    @objc private func onLongPressRunningStatusButton(_ gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.6) { [weak self] in
                self?.runningStatusButton.layer.cornerRadius = (self!.buttonSize * 1.3) / 2
                self?.runningStatusButton.backgroundColor = .systemRed
                self?.runningStatusButton.snp.updateConstraints { make in
                    make.width.equalTo(self!.buttonSize * 1.3)
                    make.height.equalTo(self!.buttonSize * 1.3)
                }
                self?.view.layoutIfNeeded()
            } completion: { _ in
            }
        case .cancelled, .failed, .ended:
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.runningStatusButton.layer.cornerRadius = (self!.buttonSize) / 2
                self?.runningStatusButton.backgroundColor = .inverted
                self?.runningStatusButton.snp.updateConstraints { make in
                    make.width.equalTo(self!.buttonSize)
                    make.height.equalTo(self!.buttonSize)
                }
                self?.view.layoutIfNeeded()
            }
        default:
            return
        }
    }
    
    deinit {
        cancelTimer()
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

// MARK: - Timer
extension RunningViewController {
    private func setupTimer() {
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer?.schedule(deadline: .now() + 1, repeating: 1)
        timer?.setEventHandler { [weak self] in
            self?.timerTicks()
        }
        resumeTimer()
    }
    
    @objc private func onTapRunningStatusButton() {
        if timerSuspended {
            resumeTimer()
            runningStatusButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: buttonImageConfig)!, for: .normal)
        } else if timerTicking {
            suspendTimer()
            runningStatusButton.setImage(UIImage(systemName: "play.fill", withConfiguration: buttonImageConfig)!, for: .normal)
        }
    }
    
    private func timerTicks() {
        seconds += 1
        let hours = seconds / 3600
        let secondsLeft = seconds - (hours * 3600)
        let minutes = secondsLeft / 60
        let seconds = secondsLeft % 60
        timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func resumeTimer() {
        if timerTicking { return }
        timerSuspended = false
        timer?.resume()
    }
    
    private func suspendTimer() {
        if timerSuspended { return }
        timerSuspended = true
        timer?.suspend()
    }
    
    private func cancelTimer() {
        if timerIdle { return }
        if timerSuspended { resumeTimer() }
        timerSuspended = true
        timer?.cancel()
    }
}
