//
//  RunningViewController.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/7/23.
//

import UIKit

class RunningViewController: UIViewController {
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        return sv
    }()
    
    private let runningCardView: UICollectionView = {
        let layout = RunningCardCollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let runningMapView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stackView)
        view.backgroundColor = .systemBackground
        buildStackView()
        buildNavigationBar()
        buildCollectionView()
        applyConstraints()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - 네비게이션 바 세팅
    private func buildNavigationBar() {
        navigationItem.title = "러닝"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - UI 세팅
    private func buildStackView() {
        stackView.addArrangedSubview(runningCardView)
        stackView.addArrangedSubview(runningMapView)
    }
    
    private func buildCollectionView() {
        runningCardView.delegate = self
        runningCardView.dataSource = self
        runningCardView.register(RunningCardCollectionViewCell.self, forCellWithReuseIdentifier: RunningCardCollectionViewCell.identifier)
    }
    
    //MARK: - 제약조건
    private func applyConstraints() {
        let stackViewConstraints = [
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        let runningHistoryViewConstraints = [
            runningCardView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.35)
        ]
        
        let runningMapViewConstraints = [
            runningMapView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.65)
        ]
        
        NSLayoutConstraint.activate(stackViewConstraints)
        NSLayoutConstraint.activate(runningHistoryViewConstraints)
        NSLayoutConstraint.activate(runningMapViewConstraints)
    }
}

// MARK: - 컬렉션 뷰 델리게이트
extension RunningViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: RunningCardCollectionViewCell.identifier, for: indexPath)
                as? RunningCardCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}
