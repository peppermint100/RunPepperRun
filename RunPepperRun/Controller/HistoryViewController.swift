//
//  HistoryViewController.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/22/24.
//

import UIKit
import FirebaseFirestore
import Charts

class HistoryViewController: UIViewController {
    
    let historyManager = HistoryManager()
    
    let stackView = UIStackView()
    private let chartSegmentedControl = UISegmentedControl()
    private var filterButton: UIBarButtonItem?
    let historyTableView = UITableView()
    let chartView = BarChartView()
   
    var chartScope = ChartScope.week {
        didSet {
            periodList = calculatePeriod(chartScope: chartScope)
        }
    }
    
    var periodIdx = 0
    var periodList: [Period] = []
    var runningStat: RunningStat = .distance(0)
    private var runningStatList: [RunningStat] = [
        .distance(0), .speed(0), .pace(0),
        .caloriesBurned(0), .numberOfSteps(0), .duration(0)
    ]
    
    var chartHistories: [History] = []
    private var recentHistories: [History] = []
    
    let today = Date()
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupStackView()
        setupChartSegmentedControl()
        setupChartView()
        loadInitialChart()
        setupRecentHistories()
        setupHistoryTableView()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "History"
        filterButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: nil)
        
        let periodMenu = UIDeferredMenuElement.uncached { [weak self] completion in
            guard let strongSelf = self else { return }
            let periodActions = strongSelf.periodList.enumerated().map { (idx, period) in
                return UIAction(
                    title: "\(period.from.toMMdd())~\(period.to.toMMdd())",
                    state: strongSelf.periodIdx == idx ? .on : .off,
                    handler: { [weak self] _ in
                        guard let strongSelf = self else { return }
                        strongSelf.periodIdx = idx
                        strongSelf.loadChart(with: strongSelf.periodList[strongSelf.periodIdx])
                    })
            }
            
            completion([UIMenu(options: .displayInline, children: periodActions)])
        }
        
        let runningStatsMenu = UIDeferredMenuElement.uncached { [weak self] completion in
            guard let strongSelf = self else { return }
            let runningStatsActions = strongSelf.runningStatList.map { runningStat in
                return UIAction(
                    title: runningStat.title,
                    image: UIImage(systemName: runningStat.sfSymbol),
                    state: strongSelf.runningStat == runningStat ? .on : .off,
                    handler: { _ in
                        strongSelf.runningStat = runningStat
                        strongSelf.loadChart(with: runningStat)
                    })
            }
            
            completion([UIMenu(options: .displayInline,children: runningStatsActions)])
        }
        
        filterButton?.menu = UIMenu(children: [periodMenu, runningStatsMenu])
        
        navigationItem.rightBarButtonItem = filterButton
    }

    private func setupRecentHistories() {
        historyManager.getHistories(limit: 3) { [weak self] result in
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
        stackView.spacing = 8
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
            make.height.equalToSuperview().multipliedBy(0.05).offset(-8)
        }
    }
    
    private func didSelectWeek() {
        periodIdx = 0
        chartScope = .week
        loadChart(with: periodList[periodIdx])
    }
    
    private func didSelectMonth() {
        periodIdx = 0
        chartScope = .month
        loadChart(with: periodList[periodIdx])
    }
    
    private func setupChartView() {
        chartScope = .month
        stackView.addArrangedSubview(chartView)
        chartView.xAxis.labelPosition = .bottom
        chartView.doubleTapToZoomEnabled = false
        chartView.leftAxis.axisMinimum = 0
        chartView.rightAxis.enabled = false
        chartView.xAxis.gridLineDashLengths = [4, 2]
        chartView.leftAxis.gridLineDashLengths = [4, 2]
        chartView.rightAxis.gridLineDashLengths = [4, 2]
        chartView.snp.makeConstraints { make in
            make.height.equalTo(stackView).multipliedBy(0.5).offset(-8)
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
             guard historyManager.isLoading else {
                 return
             }
             
             self.historyTableView.tableFooterView = createSpinnerFooter()
             
             historyManager.getHistories(isPaginating: true, limit: 3){ [weak self] result in
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
