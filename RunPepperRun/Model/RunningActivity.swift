//
//  RunningActivity.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/4/24.
//

import Foundation

enum RunningActivity {
    case distance(Double)
    case speed(Double)
    case pace(Double)
    case caloriesBurned(Double)
    case cadence(Int)
    case duration(TimeInterval)
}
