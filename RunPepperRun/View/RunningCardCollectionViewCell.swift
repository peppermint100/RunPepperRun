//
//  RunningCardCollectionViewCell.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/8/23.
//

import UIKit

class RunningCardCollectionViewCell: UICollectionViewCell {
    static let identifier = "RunningCardCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray3
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
    required init(coder: NSCoder) {
        fatalError("RunningCardCollectionViewCell 생성 실패")
    }
}
