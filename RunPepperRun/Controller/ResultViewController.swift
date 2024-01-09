//
//  ResultViewController.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/9/24.
//

import UIKit
import MapKit

class ResultViewController: UIViewController {
    
    var result: RunningResult?
    
    private let stackView = UIStackView()
    private let mapView = MKMapView()
    private let activityCollectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: ActivityCellScollLayout())
    }()
    
    private let finishButton = UIButton()
    private var activities: [RunningActivity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupStackView()
        setupMapView()
        setupActivities()
        setupActivityView()
        setupFinishButton()
    }
    
    private func setupNavigation() {
        navigationItem.title = "Result"
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    private func setupMapView() {
        stackView.addArrangedSubview(mapView)
        mapView.delegate = self
        mapView.layer.cornerRadius = 10
        mapView.clipsToBounds = true
        mapView.drawRoute(points: result?.points ?? [])
        mapView.drawPinAt(point: result?.points.first, title: "시작")
        mapView.drawPinAt(point: result?.points.last, title: "종료")
        mapView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).offset(-8).multipliedBy(0.7)
        }
    }
    
    private func setupActivities() {
        activities = [.speed(self.result?.averageSpeed ?? 0), .pace(self.result?.averagePace ?? 0), .cadence(self.result?.numberOfSteps ?? 0), .caloriesBurned(self.result?.caloriesBurend ?? 0), .distance(self.result?.distance ?? 0), .duration(self.result?.duration ?? 0)]
    }
    
    private func setupActivityView() {
        stackView.addArrangedSubview(activityCollectionView)
        activityCollectionView.register(ActivityCardCell.self, forCellWithReuseIdentifier: ActivityCardCell.identifier)
        activityCollectionView.delegate = self
        activityCollectionView.dataSource = self
        activityCollectionView.showsHorizontalScrollIndicator = false
        activityCollectionView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).multipliedBy(0.2)
        }
    }
    
    private func setupFinishButton() {
        stackView.addArrangedSubview(finishButton)
        finishButton.backgroundColor = .secondarySystemBackground
        finishButton.tintColor = .label
        finishButton.layer.cornerRadius = 10
        finishButton.clipsToBounds = true
        finishButton.setTitle("종료하고 돌아가기", for: .normal)
        finishButton.addTarget(self, action: #selector(showAlertToSave), for: .touchUpInside)
        finishButton.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).offset(-8).multipliedBy(0.1)
        }
    }
    
    @objc private func showAlertToSave() {
        let alert = UIAlertController(title: "이 런닝을 저장하시겠습니까?", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "저장", style: .default) { [weak self] okAction in
            self?.saveRunning()
            self?.popToHomeVC()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { [weak self] cancelAction in
            self?.popToHomeVC()
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func saveRunning() {
        print("러닝 저장...")
    }
    
    private func popToHomeVC() {
        navigationController?.popToRootViewController(animated: false)
    }
}

extension ResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityCardCell.identifier, for: indexPath) as! ActivityCardCell
        let activity = activities[indexPath.row]
        cell.configure(with: activity)
        return cell
    }
}

extension ResultViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKGradientPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 3
        renderer.strokeColor = .systemBlue
        return renderer
    }
}
