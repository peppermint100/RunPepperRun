//
//  RunningStatusView.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/20/23.
//

import UIKit


class RunningActivityView: UIStackView {
    
    var title: String? {
        didSet {
            titleLabel.text = oldValue
        }
    }
    
    var subTitle: String

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
        label.text = "-"
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
        label.text = subTitle
        return label
    }()
    
    init(subTitle: String) {
        self.subTitle = subTitle
        super.init(frame: .zero)
        axis = .vertical
        addArrangedSubview(titleLabel)
        addArrangedSubview(subTitleLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("RunningActivityView 생성 실패")
    }
}