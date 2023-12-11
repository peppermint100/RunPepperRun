//
//  RoundedButton.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/9/23.
//

import UIKit

protocol RoundedButtonDelegate: AnyObject {
    func didTapButton(_ button: RoundedButton)
}

class RoundedButton: UIButton {
    
    weak var delegate: RoundedButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ title: String?, color: UIColor?) {
        self.init(frame: .zero)
        backgroundColor = color ?? .systemBlue
        titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        setTitle(title ?? "", for: .normal)
        setTitleColor(.white, for: .normal)
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError("RunningMapView 생성 실패")
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 4
    }
    
    @objc private func didTapButton() {
        delegate?.didTapButton(self)
    }
}
