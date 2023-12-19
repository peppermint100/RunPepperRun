//
//  RunningStatus.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/18/23.
//

import Foundation


enum RunningStatus: Int, CaseIterable {
    case speed, pace, distance, caloriesBurned
    
    func getTitlesFrom(_ route: Route?) -> RunningStatusTitles {
        switch self {
        case .speed:
            return RunningStatusTitles(title: String(format: "%.2fkm/h", route?.speed ?? "-"), subTitle: "속도")
        case .pace:
            let paceMinutes = 1
            let paceSeconds = 12
            return RunningStatusTitles(title: String(format: "%d'%d\"", paceMinutes, paceSeconds), subTitle: "페이스")
        case .distance:
            let distanceKm = route?.distance.toKiloMeters()
            return RunningStatusTitles(title: String(format: "%.2fkm/h", distanceKm ?? "-"), subTitle: "거리")
        case .caloriesBurned:
            return RunningStatusTitles(title: String(format: "%.2fcal", route?.caloriesBurned ?? "-"), subTitle: "소모 칼로리")
        }
    }
}
