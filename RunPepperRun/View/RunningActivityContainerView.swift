//
//  RunningStatusView.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/20/23.
//

import UIKit
import MapKit

class RunningActivityContainerView: UIStackView {
    
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
    
    private let speedView: RunningActivityView = {
        let view = RunningActivityView(subTitle: "속도")
        return view
    }()
    
    private let distanceView: RunningActivityView = {
        let view = RunningActivityView(subTitle: "거리")
        return view
    }()
    
    private let paceView: RunningActivityView = {
        let view = RunningActivityView(subTitle: "페이스")
        return view
    }()
    
    private let caloriesView: RunningActivityView = {
        let view = RunningActivityView(subTitle: "소모칼로리")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(running: Running?) {
        self.init(frame: .zero)
        axis = .vertical
        distribution = .fillEqually
        addArrangedSubview(speedAndDistanceView)
        addArrangedSubview(paceAndCaloriesView)
        speedAndDistanceView.addArrangedSubview(speedView)
        speedAndDistanceView.addArrangedSubview(distanceView)
        paceAndCaloriesView.addArrangedSubview(paceView)
        paceAndCaloriesView.addArrangedSubview(caloriesView)
        running?.activity?.delegate = self
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

extension RunningActivityContainerView: RunningActivityDelegate {
    func didUpdateCaloriesBurned(_ caloriesBurned: Double) {
        setCalories(caloriesBurned.toCaloriesString())
    }
    
    func didUpdateDistance(_ distance: CLLocationDistance) {
        setDistance(distance.toKiloMetersString())
    }
    
    func didUpdateSpeed(_ speed: CLLocationSpeed) {
        setSpeed(speed.toKilometersPerHourString())
    }
}
