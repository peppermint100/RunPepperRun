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
    private let chartView = UIView()
    private let historyTableView = UITableView()
    
    var chartScope = ChartScope.week
    
    var recentHistories: [History] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        HistoryManager.shared.clearDocuments()
        setupNavigationBar()
        setupStackView()
        setupChartSegmentedControl()
        setupChartView()
        setupRecentHistories()
        setupHistoryTableView()
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
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "History"
        let image = UIImage(systemName: "slider.horizontal.3")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = button
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
        print("week..")
        chartScope = .week
    }
    
    private func didSelectMonth() {
        print("month..")
        chartScope = .month
    }
    
    private func setupChartView() {
        stackView.addArrangedSubview(chartView)
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
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    deinit {
        HistoryManager.shared.clearDocuments()
    }
}

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
}
