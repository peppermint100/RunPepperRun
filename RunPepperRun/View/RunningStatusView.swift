//
//  RunningStatusView.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/15/24.
//

import UIKit

protocol RunningStatusViewDelegate: AnyObject {
    func didTapRunningStatusButton(_ view: RunningStatusView)
    func didLongPressRunningStatusButtonCompleted(_ view: RunningStatusView)
}

class RunningStatusView: UIView {
    
    weak var delegate: RunningStatusViewDelegate?
    
    var seconds: Int = 0 {
        didSet {
            timerLabel.text = seconds.formatToHHMMSS()
        }
    }
    
    var distance: Double = 0 {
        didSet {
            distanceLabel.text = distance.formatDistance()
        }
    }
    
    var buttonIcon: UIImage = UIImage(systemName: "pause.fill")! {
        didSet {
            let buttonImageConfig = UIImage.SymbolConfiguration(pointSize: 26)
            buttonIcon.withConfiguration(buttonImageConfig)
            runningStatusButton.setImage(buttonIcon, for: .normal)
        }
    }
    
    private let timerView = UIStackView()
    private let timerIndicatorView = UIView()
    private var timerIndicatorIcon = UIImageView()
    private let timerIndicatorLabel = UILabel()
    private let timerLabel = UILabel()
    private let distanceLabel = UILabel()
    
    private let runningStatusButtonView = UIView()
    private let runningStatusButton = UIButton()
    private let buttonSize: CGFloat = 80
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubview(timerView)
        setupTimerView()
        setupRunningStatusButton()
    }
    
    required init(coder: NSCoder) {
        fatalError("RunningStatusView 생성 실패")
    }
    
    private func setupTimerView() {
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
        timerLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        timerLabel.textColor = .label
    }
    
    private func setupDistanceLabel(){
        timerView.addArrangedSubview(distanceLabel)
        distanceLabel.text = distance.formatDistance()
        distanceLabel.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        distanceLabel.textColor = .systemGray
    }
    
    private func setupRunningStatusButton() {
        addSubview(runningStatusButton)
        runningStatusButton.layer.cornerRadius = buttonSize / 2
        runningStatusButton.clipsToBounds = true
        runningStatusButton.backgroundColor = .inverted
        runningStatusButton.tintColor = .systemBackground
        runningStatusButton.setImage(buttonIcon, for: .normal)
        runningStatusButton.addTarget(self, action: #selector(didTapRunningStatusButton), for: .touchUpInside)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressRunningStatusButton(_:)))
        runningStatusButton.addGestureRecognizer(longPressGesture)
        runningStatusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview().offset(-25)
            make.width.equalTo(buttonSize)
            make.height.equalTo(buttonSize)
        }
    }
    
    @objc private func didTapRunningStatusButton() {
        delegate?.didTapRunningStatusButton(self)
    }
    
    @objc private func didLongPressRunningStatusButton(_ gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.6) { [weak self] in
                self?.runningStatusButton.layer.cornerRadius = (self!.buttonSize * 1.3) / 2
                self?.runningStatusButton.backgroundColor = .systemRed
                self?.runningStatusButton.snp.updateConstraints { make in
                    make.width.equalTo(self!.buttonSize * 1.3)
                    make.height.equalTo(self!.buttonSize * 1.3)
                }
                self?.layoutIfNeeded()
            } completion: { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.didLongPressRunningStatusButtonCompleted(self)
            }
        case .cancelled, .failed, .ended:
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.runningStatusButton.layer.cornerRadius = (self!.buttonSize) / 2
                self?.runningStatusButton.backgroundColor = .inverted
                self?.runningStatusButton.snp.updateConstraints { make in
                    make.width.equalTo(self!.buttonSize)
                    make.height.equalTo(self!.buttonSize)
                }
                self?.layoutIfNeeded()
            }
        default:
            return
        }
    }
}

