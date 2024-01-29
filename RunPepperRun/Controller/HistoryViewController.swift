//
//  HistoryViewController.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/22/24.
//

import UIKit
import FirebaseFirestore

class HistoryViewController: UIViewController {
    
    private let stackView = UIStackView()
    private let chartSegmentedControl = UISegmentedControl()
    private let historyTableView = UITableView()
    private var filterButton: UIBarButtonItem?
    
    private var chartScope = ChartScope.week {
        didSet {
            periodList = calculatePeriod(chartScope: chartScope)
        }
    }
    
    private var periodIdx = 0 {
        didSet {
            configureFilterButtonMenu()
        }
    }
    
    private var periodList: [Period] = [] {
        didSet {
            configureFilterButtonMenu()
        }
    }
    
    private var runningStat: RunningStat = .distance(0) {
        didSet {
            configureFilterButtonMenu()
        }
    }
    
    private var runningStatList: [RunningStat] = [
        .distance(0), .speed(0), .pace(0),
        .caloriesBurned(0), .numberOfSteps(0), .duration(0)
    ]
    
    private var recentHistories: [History] = []
    
    private let today = Date()
    private let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        HistoryManager.shared.clearDocuments()
        chartScope = .week
        setupStackView()
        setupChartSegmentedControl()
        setupChartView()
        setupRecentHistories()
        setupHistoryTableView()
    }
    
    private func setupNavigationBar() {
        configureFilterButtonMenu()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "History"
        filterButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = filterButton
    }

    private func setupRecentHistories() {
        HistoryManager.shared.getHistories(limit: 3) { [weak self] result in
            switch result {
            case .success(let histories):
                self?.recentHistories = histories
                self?.historyTableView.reloadData()
            case .failure(let error):
                switch error {
                case .failToGetEmail:
                    let vc = SignUpViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true)
                default:
                    return
                }
            }
        }
    }

    private func setupStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupChartSegmentedControl() {
        stackView.addArrangedSubview(chartSegmentedControl)
        chartSegmentedControl.backgroundColor = .secondarySystemBackground
        chartSegmentedControl.selectedSegmentTintColor = .systemBackground
        chartSegmentedControl.layer.cornerRadius = 8
        chartSegmentedControl.clipsToBounds = true
        let weekAction = UIAction(title: "주", handler: { [weak self] _ in self?.didSelectWeek()})
        let monthAction = UIAction(title: "월", handler: { [weak self] _ in self?.didSelectMonth()})
        chartSegmentedControl.insertSegment(action: weekAction, at: 0, animated: true)
        chartSegmentedControl.insertSegment(action: monthAction, at: 1, animated: true)
        chartSegmentedControl.selectedSegmentIndex = 0
        chartSegmentedControl.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.05)
        }
    }
    
    private func didSelectWeek() {
        periodIdx = 0
        chartScope = .week
    }
    
    private func didSelectMonth() {
        periodIdx = 0
        chartScope = .month
    }
    
    private func setupChartView() {
        stackView.addArrangedSubview(chartView)
        chartView.doubleTapToZoomEnabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.gridBackgroundColor = .systemGray5
        chartView.snp.makeConstraints { make in
            make.height.equalTo(stackView).multipliedBy(0.5)
        }
    }
    
    private func setupHistoryTableView() {
        stackView.addArrangedSubview(historyTableView)
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.rowHeight = 120
        historyTableView.separatorStyle = .none
        historyTableView.showsVerticalScrollIndicator = false
        historyTableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
    }

    deinit {
        HistoryManager.shared.clearDocuments()
    }
}

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
    
    /*
     FilterButtonMenu에 현재 선택된 Period, runngingStat에 따라서
     UIMenu를 생성
     */
    private func configureFilterButtonMenu() {
        let periodActions = periodList.enumerated().map { (idx, period) in
            return UIAction(
                title: "\(period.from.toMMdd())~\(period.to.toMMdd())",
                state: periodIdx == idx ? .on : .off,
                handler: { [weak self] _ in
                    guard let strongSelf = self else { return }
                    strongSelf.periodIdx = idx
                })
        }
        
        let periodMenu = UIMenu(options: .displayInline, children: periodActions)
        
        let runningStatsActions = runningStatList.map { runningStat in
            return UIAction(
                title: runningStat.title,
                image: UIImage(systemName: runningStat.sfSymbol),
                state: self.runningStat == runningStat ? .on : .off,
                handler: { [weak self]_ in
                    self?.runningStat = runningStat
                })
        }
        
        let runningStatsMenu = UIMenu(options: .displayInline, children: runningStatsActions)
        
        let rootMenu = UIMenu(children: [periodMenu, runningStatsMenu])
        filterButton?.menu = rootMenu
    }
}

// MARK: - RecentHistoryTableView
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentHistories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath)
            as! HistoryTableViewCell
        let history = recentHistories[indexPath.row]
        cell.configure(with: history)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let position = scrollView.contentOffset.y
         
         if position > (historyTableView.contentSize.height - 100 - scrollView.frame.size.height) {
             guard !HistoryManager.shared.isLoading else {
                 return
             }
             
             self.historyTableView.tableFooterView = createSpinnerFooter()
             
             HistoryManager.shared.getHistories(isPaginating: true, limit: 3){ [weak self] result in
                 DispatchQueue.main.async {
                     self?.historyTableView.tableFooterView = nil
                 }
                 switch result {
                 case .success(let histories):
                     DispatchQueue.main.async {
                         self?.recentHistories.append(contentsOf: histories)
                         self?.historyTableView.reloadData()
                     }
                 case .failure(_):
                     break
                 }
             }
         }
     }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
}
