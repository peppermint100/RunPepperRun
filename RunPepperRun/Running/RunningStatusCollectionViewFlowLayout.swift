//
//  RunningStatusCollectionViewFlowLayout.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/14/23.
//

import UIKit

class RunningStatusCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        scrollDirection = .horizontal
        sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("RunningCardCollectionViewFlowLayout 생성 실패")
    }
    
    override func prepare() {
        super.prepare()
        setUpCellItem()
    }
    
    private func setUpCellItem() {
        guard let collectionView = collectionView else { return }
        let cellWidth = collectionView.frame.size.width / 2 - 15
        let cellHeight = collectionView.frame.size.height / 2 - 15
        itemSize = CGSize(width: cellWidth, height: cellHeight)
    }
}
