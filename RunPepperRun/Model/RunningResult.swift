//
//  RunningResult.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/9/24.
//

import Foundation


struct RunningResult {
    let points: [Point]
    let distance: Double
    let duration: TimeInterval
    let averageSpeed: Double
    let averagePace: Double
    let caloriesBurend: Double
    let numberOfSteps: Int
    let startDate: Date
    let endDate: Date
}
