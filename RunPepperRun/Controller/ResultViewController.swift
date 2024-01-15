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
    private let runningFactorsCollectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: RunningFactorCellScrollLayout())
    }()
    
    private let finishButton = UIButton()
    private var runningFactors: [RunningFactor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupStackView()
        setupMapView()
        setupRunningFactors()
        setupRunningFactorsView()
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
        
        mapView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).offset(-8).multipliedBy(0.7)
        }
        
        guard let result = result else { return }
        
        do {
            try mapView.drawRoute(points: result.points)
        } catch let error as MapViewDrawbleError {
            mapView.drawMessageOverlay(error.description)
        } catch {
            return
        }
        
        if let startPoint = result.points.first, let endPoint = result.points.last, startPoint != endPoint {
            mapView.drawPinAt(point: startPoint, title: "시작")
            mapView.drawPinAt(point: result.points.last ?? startPoint, title: "종료")
        }
    }
    
    private func setupRunningFactors() {
        runningFactors = [.speed(self.result?.averageSpeed ?? 0), .pace(self.result?.averagePace ?? 0), .numberOfSteps(self.result?.numberOfSteps ?? 0), .caloriesBurned(self.result?.caloriesBurend ?? 0), .distance(self.result?.distance ?? 0), .duration(self.result?.duration ?? 0)]
    }
    
    private func setupRunningFactorsView() {
        stackView.addArrangedSubview(runningFactorsCollectionView)
        runningFactorsCollectionView.register(RunningFactorCardCell.self, forCellWithReuseIdentifier: RunningFactorCardCell.identifier)
        runningFactorsCollectionView.delegate = self
        runningFactorsCollectionView.dataSource = self
        runningFactorsCollectionView.showsHorizontalScrollIndicator = false
        runningFactorsCollectionView.snp.makeConstraints { make in
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
        return runningFactors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RunningFactorCardCell.identifier, for: indexPath) as! RunningFactorCardCell
        let activity = runningFactors[indexPath.row]
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