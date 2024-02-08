//
//  HistoryViewController+Chart.swift
//  RunPepperRun
//
//  Created by peppermint100 on 2/8/24.
//

import Foundation
import Charts

// MARK: - ChartFilter
extension HistoryViewController {
    private static let weekPeriodCount = 4
    private static let monthPeriodCount = 2

    /*
     SegmentedControl의 ChartScope(주, 월)에 따라서
     다른 기간 목록을 생성(Period)
     */
    func calculatePeriod(chartScope: ChartScope) -> [Period] {
        var result: [Period] = []
        
        switch chartScope {
        case .week:
            let weekday = calendar.component(.weekday, from: today)
            var sunday = calendar.date(byAdding: .weekday, value: -weekday + 1, to: today)!
            result.append(Period(from: sunday.setTimeToStartOfTheDay(), to: today.setTimeToEndOfTheDay()))
            for _ in 0..<HistoryViewController.weekPeriodCount - 1 {
                let saturday = calendar.date(byAdding: .day, value: -1, to: sunday)!
                let lastSunday = calendar.date(byAdding: .day, value: -7, to: sunday)!
                result.append(Period(from: lastSunday.setTimeToStartOfTheDay(), to: saturday.setTimeToEndOfTheDay()))
                sunday = lastSunday
            }
        case .month:
            var firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
            var lastDayOfMonth = today
            for _ in 0..<HistoryViewController.monthPeriodCount {
                result.append(Period(from: firstDayOfMonth.setTimeToStartOfTheDay(), to: lastDayOfMonth.setTimeToEndOfTheDay()))
                lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: firstDayOfMonth)!
                firstDayOfMonth = calendar.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
            }
        }
        
        return result
    }
    
    func loadInitialChart() {
        periodList = calculatePeriod(chartScope: chartScope)
        guard let period = periodList.first else { return }
        loadChart(with: period)
    }
    
    func loadChart(with period: Period) {
        historyManager.getHistories(from: period.from, to: period.to) { [weak self] result in
            switch result {
            case .success(let histories):
                guard let strongSelf = self else { return }
                strongSelf.chartHistories = histories
                strongSelf.drawChart(
                    histories: strongSelf.chartHistories,
                    period: period,
                    runningStat: strongSelf.runningStat)
            case .failure:
                return
            }
        }
    }
    
    func loadChart(with runningStat: RunningStat) {
        self.runningStat = runningStat
        drawChart(histories: chartHistories, period: periodList[periodIdx], runningStat: runningStat)
    }
    
    private func drawChart(histories: [History], period: Period, runningStat: RunningStat) {
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
