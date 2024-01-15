//
//  ActivityCardView.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/2/24.
//

import UIKit
import SnapKit

class RunningFactorCardCell: UICollectionViewCell {
    
    static let identifier = "ActivityCardCell"
    let circleSize: CGFloat = 40
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.backgroundColor = .secondarySystemBackground
        sv.layer.cornerRadius = 10
        sv.clipsToBounds = true
        return sv
    }()
    
    private let iconContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let iconCircleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 5)
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let valuesView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.text = "0"
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        applyConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("RunningFactorCardCell 생성 실패")
    }
    
    private func setupUI() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(iconContainerView)
        stackView.addArrangedSubview(valuesView)
        iconContainerView.addSubview(iconCircleView)
        iconCircleView.addSubview(iconImageView)
        valuesView.addSubview(titleLabel)
        valuesView.addSubview(subtitleLabel)
    }
    
    override func layoutSubviews() {
        iconCircleView.layer.cornerRadius = circleSize / 2
        iconCircleView.clipsToBounds = true
    }
    
    private func applyConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        iconContainerView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).multipliedBy(0.6)
        }
        
        iconCircleView.snp.makeConstraints { make in
            make.center.equalTo(iconContainerView.snp.center)
            make.height.equalTo(circleSize)
            make.width.equalTo(circleSize)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalTo(iconCircleView.snp.center)
            make.height.equalTo(circleSize - 10)
            make.width.equalTo(circleSize - 10)
        }
        
        valuesView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).multipliedBy(0.4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(valuesView.snp.leading)
            make.trailing.equalTo(valuesView.snp.trailing)
            make.top.equalTo(valuesView.snp.top)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(valuesView.snp.leading)
            make.trailing.equalTo(valuesView.snp.trailing)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
    }
    
    func configure(with activity: RunningFactor) {
        updateTitle(for: activity)
        subtitleLabel.text = subtitle(for: activity)
        iconImageView.image = UIImage(systemName: sfSymbol(for: activity))
        let iconColor = iconColor(for: activity)
        iconImageView.tintColor = iconColor
        iconCircleView.backgroundColor = iconColor.lighter()
    }
    
    private func updateTitle(for activity: RunningFactor) {
        switch activity {
        case .speed(let value):
            if value == 0 { return }
            titleLabel.text = value.formatSpeed()
            return
        case .pace(let value):
            if value == 0 { return }
            titleLabel.text = value.formatPace()
            return
        case .caloriesBurned(let value):
            if value == 0 { return }
            titleLabel.text = value.formatCaloriesBurned()
            return
        case .numberOfSteps(let value):
            if value == 0 { return }
            titleLabel.text = String(value)
            return
        case .duration(let value):
            if value == 0 { return }
            titleLabel.text = Int(value).formatToHHMMSS()
            return
        case .distance(let value):
            if value == 0 { return }
            titleLabel.text = value.formatDistance()
            return
        }
    }
    
    private func subtitle(for activity: RunningFactor) -> String {
        switch activity {
        case .speed:
            return "속도"
        case .pace:
            return "페이스"
        case .caloriesBurned:
            return "소모 칼로리"
        case .numberOfSteps:
            return "발걸음 수"
        case .duration:
            return "시간"
        case .distance:
            return "거리"
        }
    }
    
    private func iconColor(for activity: RunningFactor) -> UIColor {
        switch activity {
        case .speed:
            return .systemGreen
        case .pace:
            return .systemOrange
        case .caloriesBurned:
            return .systemRed
        case .numberOfSteps:
            return .systemBlue
        case .duration:
            return .systemCyan
        case .distance:
            return .systemBrown
        }
    }
        
    func sfSymbol(for activity: RunningFactor) -> String {
        switch activity {
        case .speed:
            return "bolt.horizontal"
        case .pace:
            return "stopwatch"
        case .caloriesBurned:
            return "flame"
        case .numberOfSteps:
            return "shoeprints.fill"
        case .distance:
            return "figure.walk"
        case .duration:
            return "hourglass"
        }
    }
}
