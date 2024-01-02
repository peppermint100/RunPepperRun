//
//  ActivityCardView.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/2/24.
//

import UIKit
import SnapKit

class ActivityCardView: UIView {
    
    var icon: UIImage
    var title: String
    var subtitle: String
    var iconColor: UIColor
    
    let circleSize: CGFloat = 50
    
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
    
    init(title: String, subtitle: String, icon: UIImage, iconColor: UIColor) {
        self.title = title
        self.subtitle = subtitle
        self.titleLabel.text = title
        self.icon = icon
        self.iconColor = iconColor
        super.init(frame: .zero)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("ActivityCardView 생성 실패")
    }
    
    private func setupUI() {
        addSubview(stackView)
        stackView.addArrangedSubview(iconContainerView)
        stackView.addArrangedSubview(valuesView)
        iconContainerView.addSubview(iconCircleView)
        iconCircleView.addSubview(iconImageView)
        valuesView.addSubview(titleLabel)
        valuesView.addSubview(subtitleLabel)
        titleLabel.text = title
        subtitleLabel.text = subtitle
        iconImageView.image = icon
        iconImageView.tintColor = iconColor
        iconCircleView.backgroundColor = iconColor.lighter()
    }
    
    override func layoutSubviews() {
        iconCircleView.layer.cornerRadius = circleSize / 2
        iconCircleView.clipsToBounds = true
    }
    
    override func updateConstraints() {
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
}
