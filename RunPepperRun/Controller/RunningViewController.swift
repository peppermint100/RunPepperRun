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
    private let running = Running()
    
    private var timer: DispatchSourceTimer?
    private var timerSuspended = true
    private var timerTicking: Bool {
        return seconds > 0 && !timerSuspended
    }
    private var timerIdle: Bool {
        return timer == nil || (timerSuspended && seconds == 0)
    }
    private var seconds = 0
    private var runningStats: [RunningStat] = []
    
    private let stackView = UIStackView()
    
    private let mapView = MKMapView()
    private let runningStatCollectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: RunningStatCellScrollLayout())
    }()
    private let runningStatusView = RunningStatusView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupStackView()
        setupMapView()
        setupRunningStats()
        setupRunningStatsView()
        setupRunningStatusView()
        setupTimer()
        setupRunning()
    }
    
    private func setupNavigation() {
        navigationItem.title = "Running"
        navigationItem.hidesBackButton = true
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
    
    private func setupRunningStats() {
        runningStats = [.speed(0), .numberOfSteps(0), .caloriesBurned(0), .pace(0)]
    }
    
    private func setupRunningStatsView() {
        stackView.addArrangedSubview(runningStatCollectionView)
        runningStatCollectionView.register(RunningStatCardCell.self, forCellWithReuseIdentifier: RunningStatCardCell.identifier)
        runningStatCollectionView.delegate = self
        runningStatCollectionView.dataSource = self
        runningStatCollectionView.showsHorizontalScrollIndicator = false
        runningStatCollectionView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).offset(-8).multipliedBy(0.2)
        }
    }
    
    private func setupRunningStatusView() {
        stackView.addArrangedSubview(runningStatusView)
        runningStatusView.delegate = self
        runningStatusView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).offset(-8).multipliedBy(0.2)
        }
    }
        
    deinit {
        cancelTimer()
    }
}

extension RunningViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return runningStats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RunningStatCardCell.identifier, for: indexPath) as! RunningStatCardCell
        let stat = runningStats[indexPath.row]
        cell.configure(with: stats)
        return cell
    }
}

extension RunningViewController: RunningDelegate {
    private func setupRunning() {
        running.delegate = self
        running.start()
    }
    
    func didUpdateRunningStats(_ running: Running, distance: Double, speed: Double, pace: Double, caloriesBurned: Double, numberOfSteps: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.runningStats = [.speed(speed), .numberOfSteps(numberOfSteps), .caloriesBurned(caloriesBurned), .pace(pace)]
            self?.runningStatusView.distance = distance
            self?.runningStatCollectionView.reloadData()
        }
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
    
    private func timerTicks() {
        seconds += 1
        runningStatusView.seconds = seconds
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

extension RunningViewController: RunningStatusViewDelegate {
    func didTapRunningStatusButton(_ view: RunningStatusView) {
        if timerSuspended {
            resumeTimer()
            runningStatusView.buttonIcon = UIImage(systemName: "pause.fill")!
            running.start()
        } else if timerTicking {
            suspendTimer()
            runningStatusView.buttonIcon = UIImage(systemName: "play.fill")!
            running.pause()
        }
    }
    
    func didLongPressRunningStatusButtonCompleted(_ view: RunningStatusView) {
        running.pause()
        let vc = ResultViewController()
        vc.result = running.getResults()
        navigationController?.pushViewController(vc, animated: true)
    }
}
