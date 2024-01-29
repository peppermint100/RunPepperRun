//
//  ChartManager.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/27/24.
//

import Foundation
import Charts

class HistoryChartManager {
    
    private let calendar = Calendar.current
    
    private let chartView: BarChartView
    
    init(chartView: BarChartView) {
        self.chartView = chartView
    }
    
    /*
     chartScope 바뀔 때
     Period 선택할 때
     runningStat 선택할 때
     */
    func drawChart(histories: [History], period: Period, runningStat: RunningStat) {
        let bars = createEmptyBars(period: period)
        for history in histories {
            let startDate = history.startDate
            for bar in bars {
                if Calendar.current.isDate(startDate, inSameDayAs: bar.date) {
                    bar.histories.append(history)
                }
            }
        }
        
        let dateList = bars.map({ $0.date.toMMdd() })
        let values = bars.map { gatherRunningStatBy(histories: $0.histories, runningStat: runningStat)}
        setChart(x: dateList, y: values, runningStat: runningStat)
    }
    
    private func gatherRunningStatBy(histories: [History], runningStat: RunningStat) -> Double {
        switch runningStat {
        case .distance:
            return (histories.reduce(0.0) { partialResult, history in
                return partialResult + history.distance
            })
        case .speed:
            return (histories.reduce(0.0) { partialResult, history in
                return partialResult + history.averageSpeed
            })
        case .pace:
            return histories.reduce(0.0) { partialResult, history in
                return partialResult + history.averagePace
            }
        case .caloriesBurned:
            return histories.reduce(0.0) { partialResult, history in
                return partialResult + history.caloriesBurned
            }
        case .numberOfSteps:
            return histories.reduce(0.0) { partialResult, history in
                return partialResult + Double(history.numberOfSteps)
            }
        case .duration:
            let duration =  histories.reduce(0.0) { partialResult, history in
                let newTimeInterval = history.endDate.timeIntervalSince(history.startDate)
                return partialResult + newTimeInterval
            }
            return duration
        }
    }
   
    private func createEmptyBars(period: Period) -> [HistoryBar] {
        var bars: [HistoryBar] = []
        var from = period.from
        let to = period.to
        while from <= to {
            bars.append(HistoryBar(date: from))
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: from) else {
                break
            }
            from = nextDate
        }
        return bars
    }
    
    private func setChart(x: [String], y: [Double], runningStat: RunningStat) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<x.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: y[i])
            dataEntries.append(dataEntry)
        }
        
        let unitString = runningStat.unitForChart == "" ? "" : "\(runningStat.unitForChart)"

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "\(runningStat.title)(\(unitString))")
        chartDataSet.valueFormatter = RunningStatBarValueFormatter(runningStat: runningStat)
        chartDataSet.colors = [runningStat.color]

        let chartData = BarChartData(dataSet: chartDataSet)
        chartView.data = chartData
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: x)
        chartView.leftAxis.valueFormatter = RunningStatLeftAxisValueFormatter(runningStat: runningStat)
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
}

