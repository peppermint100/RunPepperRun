//
//  RunningStatusView.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/20/23.
//

import UIKit


class RunningStatusView: UIStackView {

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
        axis = .vertical
        addArrangedSubview(titleLabel)
        addArrangedSubview(subTitleLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("RunningStatusView 생성 실패")
    }
}
