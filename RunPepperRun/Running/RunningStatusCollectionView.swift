//
//  SpotifyCollectionView.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/14/23.
//

import UIKit

class RunningStatusCollectionView: UICollectionView {
    
    override private init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    convenience init() {
        let layout = RunningStatusCollectionViewFlowLayout()
        self.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
    }
    
    required init(coder: NSCoder) {
        fatalError("RunningStatusCollectionView 생성 실패")
    }
    
    func setUpCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        self.delegate = delegate
        self.dataSource = dataSource
        register(RunningStatusCollectionViewCell.self, forCellWithReuseIdentifier: RunningStatusCollectionViewCell.identifier)
    }
}
