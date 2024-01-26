//
//  History.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/22/24.
//

import Foundation


import FirebaseFirestore

struct History: Codable {
    let email: String?
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
    
    init(email: String?, averageSpeed: Double, averagePace: Double, distance: Double, caloriesBurned: Double, numberOfSteps: Int, locations: [Point], startDate: Date, endDate: Date, year: Int, month: Int, day: Int) {
        self.email = email
        self.averageSpeed = averageSpeed
        self.averagePace = averagePace
        self.distance = distance
        self.caloriesBurned = caloriesBurned
        self.numberOfSteps = numberOfSteps
        self.locations = locations
        self.startDate = startDate
        self.endDate = endDate
        self.year = year
        self.month = month
        self.day = day
    }
    
    init?(data: [String: Any]){
        guard
            let email = data["email"] as? String,
            let averageSpeed = data["averageSpeed"] as? Double,
            let averagePace = data["averagePace"] as? Double,
            let distance = data["distance"] as? Double,
            let caloriesBurned = data["caloriesBurned"] as? Double,
            let numberOfSteps = data["numberOfSteps"] as? Int,
            let locations = data["locations"] as? [Point],
            let startDate = data["startDate"] as? Date,
            let endDate = data["endDate"] as? Date,
            let year = data["year"] as? Int,
            let month = data["month"] as? Int,
            let day = data["day"] as? Int
        else { 
            return nil
        }
        self.email = email
        self.averageSpeed = averageSpeed
        self.averagePace = averagePace
        self.distance = distance
        self.caloriesBurned = caloriesBurned
        self.numberOfSteps = numberOfSteps
        self.locations = locations
        self.startDate = startDate
        self.endDate = endDate
        self.year = year
        self.month = month
        self.day = day
    }
}
