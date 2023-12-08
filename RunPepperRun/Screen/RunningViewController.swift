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
    
    private let runningHistoryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
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
        buildNavigationBar()
        buildStackView()
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
        stackView.addArrangedSubview(runningHistoryView)
        stackView.addArrangedSubview(runningMapView)
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
            runningHistoryView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.35)
        ]
        
        let runningMapViewConstraints = [
            runningMapView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.65)
        ]
        
        NSLayoutConstraint.activate(stackViewConstraints)
        NSLayoutConstraint.activate(runningHistoryViewConstraints)
        NSLayoutConstraint.activate(runningMapViewConstraints)
    }
}
