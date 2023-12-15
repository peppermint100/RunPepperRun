//
//  RunningStatusCollectionViewCell.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/15/23.
//

import UIKit

class RunningStatusCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RunningStatusCollectionViewCell"
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        return sv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        let fontSize: CGFloat = 40
        let boldItalicDescriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: .headline)
            .withSymbolicTraits([.traitBold, .traitItalic])
        let boldItalicFont = UIFont(descriptor: boldItalicDescriptor!, size: fontSize)
        label.font = boldItalicFont
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "속도"
        let fontSize: CGFloat = 18
        let boldItalicDescriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: .headline)
            .withSymbolicTraits([.traitBold, .traitItalic])
        let boldItalicFont = UIFont(descriptor: boldItalicDescriptor!, size: fontSize)
        label.font = boldItalicFont
        label.textColor = .systemGray4
        label.textAlignment = .center
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
