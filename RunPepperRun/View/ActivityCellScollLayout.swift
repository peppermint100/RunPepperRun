//
//  ActivityCellLayout.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/4/24.
//

import UIKit

class ActivityCellScollLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
    }
    
    required init(coder: NSCoder) {
        fatalError("ActivityCellLayout 생성 실패")
    }
    
    override func prepare() {
        super.prepare()
        guard let cv = collectionView else { return }
        let padding: CGFloat = 8
        let minimumItemSpacing: CGFloat = 10
        let width = cv.frame.width - (padding * 2) - (minimumItemSpacing * 2) - 20
        let itemWidth = width / 3
        itemSize = CGSize(width: itemWidth, height: itemWidth + 20)
        sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        scrollDirection = .horizontal
    }
}
