//
//  RoundedButton.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/9/23.
//

import UIKit


class RoundedButton: UIButton {
    
    var shadow = false

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ title: String?, color: UIColor?, shadow: Bool) {
        self.init(frame: .zero)
        self.shadow = shadow
        backgroundColor = color ?? .systemBlue
        titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        setTitle(title ?? "", for: .normal)
        setTitleColor(.white, for: .normal)
    }
    
    required init(coder: NSCoder) {
        fatalError("RunningMapView 생성 실패")
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
        if shadow {
            layer.shadowColor = UIColor.systemGray.cgColor
            layer.shadowOffset = .zero
            layer.shadowOpacity = 1.0
            layer.shadowRadius = 4
        }
    }
}
