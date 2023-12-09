//
//  RunningCardCollectionViewFlowLayout.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/8/23.
//

import UIKit

class RunningCardCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        scrollDirection = .horizontal
        minimumLineSpacing = 30
        sectionInset = UIEdgeInsets(top: 30, left: 40, bottom: 30, right: 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("RunningCardCollectionViewFlowLayout 생성 실패")
    }
    
    override func prepare() {
        super.prepare()
        buildCellItem()
    }
    
    private func buildCellItem() {
        guard let collectionView = collectionView else { return }
        let cellWidth = collectionView.frame.size.width - 110
        let cellHeight = collectionView.frame.size.height - 60
        itemSize = CGSize(width: cellWidth, height: cellHeight)
    }
}
