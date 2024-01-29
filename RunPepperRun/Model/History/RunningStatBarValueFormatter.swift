//
//  RunningStatValueFormatter.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/29/24.
//

import Foundation
import Charts

class RunningStatBarValueFormatter: ValueFormatter {
    var runningStat: RunningStat?
    
    convenience init(runningStat: RunningStat) {
        self.init()
        self.runningStat = runningStat
    }
    
    func stringForValue(_ value: Double, entry: Charts.ChartDataEntry, dataSetIndex: Int, viewPortHandler: Charts.ViewPortHandler?) -> String {
        if value == 0 {
            return ""
        }
        
        switch runningStat {
        case .distance:
            return String(value.metersToKilometers())
        case .speed:
            return String(value.mpsToKph().truncatePoint(to: 2))
        case .pace:
            return value.formatPace()
        case .caloriesBurned:
            return String(value.truncatePoint(to: 2))
        case .numberOfSteps:
            return String(value)
        case .duration:
            let hour = value / 3600
            return String(hour.truncatePoint(to: 1))
        case nil:
            return ""
        }
    }
}
