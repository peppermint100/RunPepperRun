//
//  History.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/22/24.
//

import Foundation

/*
 + id: UUID
 + averagePace: Double
 + averageSpeed: Double
 + distance: Double
 + caloriesBurned: Double
 + numberOfSteps: Int
 + duration: TimeInterval
 + locations: [Point]
 + createdDate: Date
 + startDate: Date + year: Int
 + month: Int
 + day: Int
 */
import FirebaseFirestore

struct History: Codable {
    let averageSpeed: Double
    let averagePace: Double
    let distance: Double
    let caloriesBurned: Double
    let numberOfSteps: Int
    let locations: [Point]
    let startDate: Date
    let endDate: Date
    var year: Int
    var month: Int
    var day: Int
}
