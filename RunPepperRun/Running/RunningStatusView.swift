//
//  RunningStatusView.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/20/23.
//

import UIKit

class RunningStatusView: UIStackView {
    
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
        axis = .vertical
        addArrangedSubview(titleLabel)
        addArrangedSubview(subTitleLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("RunningStatusView 생성 실패")
    }
}
