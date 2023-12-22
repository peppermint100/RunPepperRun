//
//  RunningStatusView.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/20/23.
//

import UIKit

class RunningStatusContainerView: UIStackView {
    
    var tracker: Tracker?
    
    private let speedAndDistanceView: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.alignment = .center
        return sv
    }()
    
    private let paceAndCaloriesView: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.alignment = .center
        return sv
    }()
    
    private let speedView: RunningStatusView = {
        let view = RunningStatusView(subTitle: "속도")
        return view
    }()
    
    private let distanceView: RunningStatusView = {
        let view = RunningStatusView(subTitle: "거리")
        return view
    }()
    
    private let paceView: RunningStatusView = {
        let view = RunningStatusView(subTitle: "페이스")
        return view
    }()
    
    private let caloriesView: RunningStatusView = {
        let view = RunningStatusView(subTitle: "소모칼로리")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(tracker: Tracker?) {
        self.init(frame: .zero)
        self.tracker = tracker
        axis = .vertical
        distribution = .fillEqually
        addArrangedSubview(speedAndDistanceView)
        addArrangedSubview(paceAndCaloriesView)
        speedAndDistanceView.addArrangedSubview(speedView)
        speedAndDistanceView.addArrangedSubview(distanceView)
        paceAndCaloriesView.addArrangedSubview(paceView)
        paceAndCaloriesView.addArrangedSubview(caloriesView)
        tracker?.delegate = self
    }
    
    required init(coder: NSCoder) {
        fatalError("RunningStatusView 생성 실패")
    }
    
    func setSpeed(_ speed: String) {
        speedView.title = speed
    }
    
    func setDistance(_ distance: String) {
        distanceView.title = distance
    }
    
    func setPace(_ pace: String) {
        paceView.title = pace
    }
    
    func setCalories(_ calories: String) {
        caloriesView.title = calories
    }
}

// MARK: - TrackerDelegate
extension RunningStatusContainerView: TrackerDelegate {
    func tracker(_ tracker: Tracker, updateSpeed: String) {
        setSpeed(updateSpeed)
    }
    
    func tracker(_ tracker: Tracker, updateDistance: String) {
        setDistance(updateDistance)
    }
}
