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
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
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
    
    private let stopButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stopButton: RoundedButton = {
        let button = RoundedButton("정지", color: .systemYellow)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let endButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let endButton: RoundedButton = {
        let button = RoundedButton("종료", color: .systemRed)
        button.translatesAutoresizingMaskIntoConstraints = false
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
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        stackView.addArrangedSubview(timerView)
        stackView.addArrangedSubview(runningStatusView)
        stackView.addArrangedSubview(buttonsView)
        timerView.addSubview(timerLabel)
        buttonsView.addArrangedSubview(stopAndEndButtonView)
        buttonsView.addArrangedSubview(spotifyButtonView)
        stopAndEndButtonView.addArrangedSubview(stopButtonView)
        stopAndEndButtonView.addArrangedSubview(endButtonView)
        endButtonView.addSubview(endButton)
        stopButtonView.addSubview(stopButton)
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
            stopButton.centerXAnchor.constraint(equalTo: stopButtonView.centerXAnchor),
            stopButton.centerYAnchor.constraint(equalTo: stopButtonView.centerYAnchor),
            stopButton.widthAnchor.constraint(equalTo: stopButtonView.widthAnchor, multiplier: 0.7),
            stopButton.heightAnchor.constraint(equalTo: stopButtonView.widthAnchor, multiplier: 0.7),
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
    
// MARK: - Timer 관련
    private func buildTimer() {
        if timer != nil { return }
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer?.schedule(deadline: .now() + 1, repeating: 1)
        timer?.setEventHandler(handler: timerTicks)
        timer?.resume()
    }
    
    private func timerTicks() {
        seconds += 1
        let minutes = seconds / 60
        let secondsOnTimer = seconds % 60
        let text = String(format: "%02d:%02d", minutes, secondsOnTimer)
        print(text)
        timerLabel.text = text
    }
    
    deinit {
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
        stopButton.delegate = self
        endButton.delegate = self
    }
    
    func didTapButton(_ button: RoundedButton) {
        if button == endButton {
            locationManager.stopUpdatingLocation()
            timer?.suspend()
            showEndRunningAlert()
            return
        }
        
        if button == stopButton {
            timer?.suspend()
        }
    }
    
    private func showEndRunningAlert() {
        let alert = UIAlertController(title: "런닝을 종료합니다.", message: "런닝을 종료합니다.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "종료", style: .destructive) { [weak self] okAction in
            self?.timer?.suspend()
            self?.presentToRunningResultVC()
        }
        
        let cancel = UIAlertAction(title: "재개", style: .cancel) { [weak self] cancelAction in
            self?.locationManager.startUpdatingLocation()
            self?.timer?.resume()
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
