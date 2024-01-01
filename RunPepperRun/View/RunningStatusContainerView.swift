//
//  RunningStatusView.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/20/23.
//

import UIKit

class RunningStatusContainerView: UIStackView {
    
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
        let view = RunningStatusView() 
        return view
    }()
    
    private let distanceView: RunningStatusView = {
        let view = RunningStatusView() 
        return view
    }()
    
    private let paceView: RunningStatusView = {
        let view = RunningStatusView() 
        return view
    }()
    
    private let caloriesView: RunningStatusView = {
        let view = RunningStatusView() 
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        distribution = .fillEqually
        addArrangedSubview(speedAndDistanceView)
        addArrangedSubview(paceAndCaloriesView)
        speedAndDistanceView.addArrangedSubview(speedView)
        speedAndDistanceView.addArrangedSubview(distanceView)
        paceAndCaloriesView.addArrangedSubview(paceView)
        paceAndCaloriesView.addArrangedSubview(caloriesView)
    }
    
    required init(coder: NSCoder) {
        fatalError("RunningStatusView 생성 실패")
    }
}
