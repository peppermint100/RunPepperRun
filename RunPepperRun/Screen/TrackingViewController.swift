//
//  TrackingViewController.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/10/23.
//

import UIKit
import MapKit


class TrackingViewController: UIViewController {
    var tracker: Tracker?
    private var timer: DispatchSourceTimer?
    private var seconds = 0
    private var timerSuspended = true

    private var timerTicking: Bool {
        return !timerSuspended && seconds > 0
    }
    
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
    
    private let runningStatusView: RunningStatusContainerView = {
        let view = RunningStatusContainerView()
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
    
    private let roundedButtonsView: UIStackView = {
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
    
    private let connectToSpotifyButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "SpotifyIcon")
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        config.image = image
        config.imagePadding = 5
        config.imagePlacement = .leading
        config.titleAlignment = .trailing
        config.attributedTitle = AttributedString("Spotify 연동하기", attributes: titleContainer)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.backgroundColor = UIColor(red: 25/255, green: 185/255, blue: 84/255, alpha: 1)
        button.tintColor = .black
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpRoundedButtons()
        applyConstraints()
        setUpTimer()
    }
    
// MARK: - UI 설정
    private func setUpUI() {
        view.backgroundColor = .systemCyan
        view.addSubview(stackView)
        stackView.addArrangedSubview(timerView)
        stackView.addArrangedSubview(runningStatusView)
        stackView.addArrangedSubview(buttonsView)
        timerView.addSubview(timerLabel)
        buttonsView.addArrangedSubview(roundedButtonsView)
        buttonsView.addArrangedSubview(spotifyButtonView)
        roundedButtonsView.addArrangedSubview(pauseAndResumeButtonView)
        roundedButtonsView.addArrangedSubview(endButtonView)
        endButtonView.addSubview(endButton)
        pauseAndResumeButtonView.addSubview(pauseAndResumeButton)
        spotifyButtonView.addSubview(connectToSpotifyButton)
    }
    
    private func applyConstraints() {
        let stackViewConstraints = [
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        
        let timerViewConstraints = [
            timerView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.3),
        ]
        
        let runningStatusViewConstraints = [
            runningStatusView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.3),
        ]
        
        let buttonsViewConstraints = [
            buttonsView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.4),
        ]
        
        let timerLabelConstraints = [
            timerLabel.centerXAnchor.constraint(equalTo: timerView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerView.centerYAnchor),
        ]
        
        let pauseAndResumeButtonConstraints = [
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
        
        let connectToSpotifyButtonConstraints = [
            connectToSpotifyButton.centerXAnchor.constraint(equalTo: spotifyButtonView.centerXAnchor),
            connectToSpotifyButton.centerYAnchor.constraint(equalTo: spotifyButtonView.centerYAnchor),
            connectToSpotifyButton.widthAnchor.constraint(equalTo: spotifyButtonView.widthAnchor, multiplier: 0.80),
            connectToSpotifyButton.heightAnchor.constraint(equalTo: spotifyButtonView.heightAnchor, multiplier: 0.45),
        ]
     
        NSLayoutConstraint.activate(stackViewConstraints)
        NSLayoutConstraint.activate(timerViewConstraints)
        NSLayoutConstraint.activate(runningStatusViewConstraints)
        NSLayoutConstraint.activate(buttonsViewConstraints)
        NSLayoutConstraint.activate(timerLabelConstraints)
        NSLayoutConstraint.activate(pauseAndResumeButtonConstraints)
        NSLayoutConstraint.activate(endButtonConstraints)
        NSLayoutConstraint.activate(connectToSpotifyButtonConstraints)
    }
    
    deinit {
        invalidateTimer()
    }
}

// MARK: - Timer 관련
extension TrackingViewController {
    private func setUpTimer() {
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
        updateRunningStatusCells()
    }
    
    private func suspendTimer() {
        if timerSuspended {
            return
        }
        timerSuspended = true
        timer?.suspend()
    }
    
    private func resumeTimer() {
        if timerTicking {
            return
        }
        timerSuspended = false
        timer?.resume()
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

// MARK: - RoundedButton 관련
extension TrackingViewController {
    private func setUpRoundedButtons() {
        pauseAndResumeButton.addTarget(self, action: #selector(tapPauseAndResumeButton), for: .touchUpInside)
        endButton.addTarget(self, action: #selector(tapEndButton), for: .touchUpInside)
    }
    
    @objc private func tapEndButton() {
        tracker?.stopUpdatingLocation()
        suspendTimer()
        showEndRunningAlert()
    }
    
    @objc private func tapPauseAndResumeButton() {
        if timerTicking {
            tracker?.stopUpdatingLocation()
            suspendTimer()
            pauseAndResumeButton.setTitle("재개", for: .normal)
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.view.backgroundColor = .systemYellow
                self?.pauseAndResumeButton.backgroundColor = .systemCyan
            }
        } else if timerSuspended {
            tracker?.startUpdatingLocation()
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
            self?.tracker?.startUpdatingLocation()
            self?.resumeTimer()
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    private func presentToRunningResultVC() {
        let vc = RunningResultViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.tracker = tracker
        present(vc, animated: false)
    }
}

