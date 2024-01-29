//
//  RunningActivity.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/4/24.
//

import UIKit


enum RunningStat: Equatable {
    case distance(Double)
    case speed(Double)
    case pace(Double)
    case caloriesBurned(Double)
    case numberOfSteps(Int)
    case duration(TimeInterval)
    
    var title: String {
        switch self {
        case .speed:
            return "속도"
        case .pace:
            return "페이스"
        case .caloriesBurned:
            return "소모 칼로리"
        case .numberOfSteps:
            return "발걸음 수"
        case .duration:
            return "시간"
        case .distance:
            return "거리"
        }
    }
    
    var sfSymbol: String {
        switch self {
        case .speed:
            return "bolt.horizontal"
        case .pace:
            return "stopwatch"
        case .caloriesBurned:
            return "flame"
        case .numberOfSteps:
            return "shoeprints.fill"
        case .distance:
            return "figure.walk"
        case .duration:
            return "hourglass"
        }
    }
    
    var color: UIColor {
        switch self {
        case .speed:
            return .systemGreen
        case .pace:
            return .systemOrange
        case .caloriesBurned:
            return .systemRed
        case .numberOfSteps:
            return .systemBlue
        case .duration:
            return .systemCyan
        case .distance:
            return .systemBrown
        }
    }
}
