//
//  TrackingViewController.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/10/23.
//

import UIKit
import MapKit

class TrackingViewController: UIViewController {
    
    private var timer: DispatchSourceTimer?
    private var seconds = 0
    private var timerSuspended = true
    private let locationManager = CLLocationManager()
    private var route = Route()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        return sv
    }()
    
    private let timerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        label.text = "00:00"
        label.textColor = .label
        return label
    }()
    
    private let runningStatusView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let buttonsView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fillEqually
        return sv
    }()
    
    private let stopAndEndButtonView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        return view
    }()
    
    private let pauseAndResumeButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pauseAndResumeButton: RoundedButton = {
        let button = RoundedButton("정지", color: .systemYellow, shadow: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        return button
    }()
    
    private let endButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let endButton: RoundedButton = {
        let button = RoundedButton("종료", color: .systemRed, shadow: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        return button
    }()
    
    private let spotifyButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
        buildUI()
        applyConstraints()
        buildRoundedButtons()
        buildTimer()
    }
    
// MARK: - UI 설정
    private func buildUI() {
        view.backgroundColor = .systemCyan
        view.addSubview(stackView)
        stackView.addArrangedSubview(timerView)
        stackView.addArrangedSubview(runningStatusView)
        stackView.addArrangedSubview(buttonsView)
        timerView.addSubview(timerLabel)
        buttonsView.addArrangedSubview(stopAndEndButtonView)
        buttonsView.addArrangedSubview(spotifyButtonView)
        stopAndEndButtonView.addArrangedSubview(pauseAndResumeButtonView)
        stopAndEndButtonView.addArrangedSubview(endButtonView)
        endButtonView.addSubview(endButton)
        pauseAndResumeButtonView.addSubview(pauseAndResumeButton)
    }
    
    private func applyConstraints() {
        let stackViewConstraints = [
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        
        let timerViewConstraints = [
            timerView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.4),
        ]
        
        let runningStatusViewConstraints = [
            runningStatusView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.2),
        ]
        
        let buttonsViewConstraints = [
            buttonsView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.4),
        ]
        
        let timerLabelConstraints = [
            timerLabel.centerXAnchor.constraint(equalTo: timerView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerView.centerYAnchor),
        ]
        
        let stopButtonConstraints = [
            pauseAndResumeButton.centerXAnchor.constraint(equalTo: pauseAndResumeButtonView.centerXAnchor),
            pauseAndResumeButton.centerYAnchor.constraint(equalTo: pauseAndResumeButtonView.centerYAnchor),
            pauseAndResumeButton.widthAnchor.constraint(equalTo: pauseAndResumeButtonView.widthAnchor, multiplier: 0.7),
            pauseAndResumeButton.heightAnchor.constraint(equalTo: pauseAndResumeButtonView.widthAnchor, multiplier: 0.7),
        ]
        
        let endButtonConstraints = [
            endButton.centerXAnchor.constraint(equalTo: endButtonView.centerXAnchor),
            endButton.centerYAnchor.constraint(equalTo: endButtonView.centerYAnchor),
            endButton.widthAnchor.constraint(equalTo: endButtonView.widthAnchor, multiplier: 0.7),
            endButton.heightAnchor.constraint(equalTo: endButtonView.widthAnchor, multiplier: 0.7),
        ]
     
        NSLayoutConstraint.activate(stackViewConstraints)
        NSLayoutConstraint.activate(timerViewConstraints)
        NSLayoutConstraint.activate(runningStatusViewConstraints)
        NSLayoutConstraint.activate(buttonsViewConstraints)
        NSLayoutConstraint.activate(timerLabelConstraints)
        NSLayoutConstraint.activate(stopButtonConstraints)
        NSLayoutConstraint.activate(endButtonConstraints)
    }
    
    deinit {
        invalidateTimer()
    }
}

// MARK: - Timer 관련
extension TrackingViewController {
    private func buildTimer() {
        if timer != nil { return }
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer?.schedule(deadline: .now() + 1, repeating: 1)
        timer?.setEventHandler { [weak self] in
            self?.timerTicks()
        }
        resumeTimer()
    }
    
    private func timerTicks() {
        seconds += 1
        timerLabel.text = String(format: "%02d:%02d", seconds/60, seconds%60)
    }
    
    private func suspendTimer() {
        timerSuspended = true
        timer?.suspend()
    }
    
    private func resumeTimer() {
        timerSuspended = false
        timer?.resume()
    }
    
    private func isTimerIdle() -> Bool {
        return timerSuspended && seconds == 0
    }
    
    private func isTimerTicking() -> Bool {
        return !timerSuspended && seconds > 0
    }
    
    private func invalidateTimer() {
        if timerSuspended {
            timer?.resume()
        }
        seconds = 0
        timerSuspended = true
        timer?.cancel()
        timer = nil
    }
}


// MARK: - LocationManager 델리게이트
extension TrackingViewController: CLLocationManagerDelegate {
    private func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            route.addLocation(location)
        }
    }
}

// MARK: - Buttons 델리게이트
extension TrackingViewController: RoundedButtonDelegate {
    private func buildRoundedButtons() {
        pauseAndResumeButton.delegate = self
        endButton.delegate = self
    }
    
    func didTapButton(_ button: RoundedButton) {
        
        if button == endButton {
            tapEndButton()
        }
        
        else if button == pauseAndResumeButton {
            tapStopButton()
        }
    }
    
    private func tapEndButton() {
        locationManager.stopUpdatingLocation()
        suspendTimer()
        showEndRunningAlert()
    }
    
    private func tapStopButton() {
        if isTimerTicking() {
            locationManager.stopUpdatingLocation()
            suspendTimer()
            pauseAndResumeButton.setTitle("재개", for: .normal)
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.view.backgroundColor = .systemYellow
                self?.pauseAndResumeButton.backgroundColor = .systemGreen
            }
        } else if timerSuspended {
            locationManager.startUpdatingLocation()
            resumeTimer()
            pauseAndResumeButton.setTitle("정지", for: .normal)
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.view.backgroundColor = .systemCyan
                self?.pauseAndResumeButton.backgroundColor = .systemYellow
            }
        }
    }
    
    private func showEndRunningAlert() {
        let alert = UIAlertController(title: "런닝을 종료합니다.", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "종료", style: .destructive) { [weak self] okAction in
            self?.suspendTimer()
            self?.presentToRunningResultVC()
        }
        
        let cancel = UIAlertAction(title: "재개", style: .cancel) { [weak self] cancelAction in
            self?.locationManager.startUpdatingLocation()
            self?.resumeTimer()
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    private func presentToRunningResultVC() {
        let vc = RunningResultViewController()
        vc.route = route
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
}
