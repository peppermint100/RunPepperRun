//
//  RunningStatusCollectionViewCell.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/15/23.
//

import UIKit


class RunningStatusCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RunningStatusCollectionViewCell"
    var titles: RunningStatusTitles? = RunningStatusTitles(title: "-", subTitle: "-") {
        didSet {
            titleLabel.text = titles?.title
            subTitleLabel.text = titles?.subTitle
        }
    }

    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        return sv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        let fontSize: CGFloat = 30
        let boldItalicDescriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: .headline)
            .withSymbolicTraits([.traitBold, .traitItalic])
        let boldItalicFont = UIFont(descriptor: boldItalicDescriptor!, size: fontSize)
        label.font = boldItalicFont
        label.textColor = .label
        label.textAlignment = .center
        label.text = titles?.title
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        let fontSize: CGFloat = 18
        let boldItalicDescriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: .headline)
            .withSymbolicTraits([.traitBold, .traitItalic])
        let boldItalicFont = UIFont(descriptor: boldItalicDescriptor!, size: fontSize)
        label.font = boldItalicFont
        label.textColor = .systemGray2
        label.textAlignment = .center
        label.text = titles?.subTitle
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        applyConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("RunningStatusCollectionViewCell 생성 실패")
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(lessThanOrEqualTo: self.contentView.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(greaterThanOrEqualTo: self.contentView.bottomAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
    }
}
