//
//  ActivityCardView.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/2/24.
//

import UIKit
import SnapKit

class ActivityCardCell: UICollectionViewCell {
    
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
        label.text = "!23123"
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
        fatalError("ActivityCardView 생성 실패")
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
        
        super.updateConstraints()
    }
    
    func configure(with activity: RunningActivity) {
        titleLabel.text = title(for: activity)
        subtitleLabel.text = subtitle(for: activity)
        iconImageView.image = UIImage(systemName: sfSymbol(for: activity))
        let iconColor = iconColor(for: activity)
        iconImageView.tintColor = iconColor
        iconCircleView.backgroundColor = iconColor.lighter()
    }
    
    private func title(for activity: RunningActivity) -> String {
        switch activity {
        case .distance(let value):
            return String(value)
        case .speed(let value):
            return String(value)
        case .pace(let value):
            return String(value)
        case .caloriesBurned(let value):
            return String(value)
        case .cadence(let value):
            return String(value)
        case .duration(let value):
            return String(value)
        }
    }
    
    private func subtitle(for activity: RunningActivity) -> String {
        switch activity {
        case .distance:
            return "거리"
        case .speed:
            return "속도"
        case .pace:
            return "페이스"
        case .caloriesBurned:
            return "소모 칼로리"
        case .cadence:
            return "발걸음 수"
        case .duration:
            return "시간"
        }
    }
    
    private func iconColor(for activity: RunningActivity) -> UIColor {
        switch activity {
        case .distance:
            return .systemYellow
        case .speed:
            return .systemGreen
        case .pace:
            return .systemOrange
        case .caloriesBurned:
            return .systemRed
        case .cadence:
            return .systemBlue
        case .duration:
            return .systemPurple
        }
    }
        
    func sfSymbol(for activity: RunningActivity) -> String {
        switch activity {
        case .distance:
            return "figure.walk"
        case .speed:
            return "bolt.horizontal"
        case .pace:
            return "stopwatch"
        case .caloriesBurned:
            return "flame"
        case .cadence:
            return "shoeprints.fill"
        case .duration:
            return "clock"
        }
    }
}
