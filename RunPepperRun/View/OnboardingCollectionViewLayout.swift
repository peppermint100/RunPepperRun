//
//  OnboardingCollectionViewLayout.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/19/24.
//

import UIKit

class OnboardingCollectionViewLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
    }
    
    required init(coder: NSCoder) {
        fatalError("OnboardingCollectionViewLayout 생성 실패")
    }
    
    override func prepare() {
        super.prepare()
        guard let cv = collectionView else { return }
        let width = cv.frame.width
        let height = cv.frame.height
        itemSize = CGSize(width: width, height: height)
        scrollDirection = .horizontal
        minimumLineSpacing = 0
    }
}
