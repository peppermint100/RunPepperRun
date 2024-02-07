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
        return UICollectionView(frame: .zero, collectionViewLayout: RunningStatCellScrollLayout())
    }()
    
    private let finishButton = UIButton()
    private var runningStats: [RunningStat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupStackView()
        setupMapView()
        setupRunningStats()
        setupRunningStatsView()
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
            print(error.localizedDescription)
            return
        }
        
        if let startPoint = result.points.first, let endPoint = result.points.last, startPoint != endPoint {
            mapView.drawPinAt(point: startPoint, title: "시작")
            mapView.drawPinAt(point: result.points.last ?? startPoint, title: "종료")
        }
    }
    
    private func setupRunningStats() {
        runningStats = [.speed(self.result?.averageSpeed ?? 0), .pace(self.result?.averagePace ?? 0), .numberOfSteps(self.result?.numberOfSteps ?? 0), .caloriesBurned(self.result?.caloriesBurned ?? 0), .distance(self.result?.distance ?? 0), .duration(self.result?.duration ?? 0)]
    }
    
    private func setupRunningStatsView() {
        stackView.addArrangedSubview(runningFactorsCollectionView)
        runningFactorsCollectionView.register(RunningStatCardCell.self, forCellWithReuseIdentifier: RunningStatCardCell.identifier)
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
        finishButton.layer.cornerRadius = 10
        finishButton.clipsToBounds = true
        finishButton.setTitle("종료하고 돌아가기", for: .normal)
        finishButton.setTitleColor(.label, for: .normal)
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
        guard let result = result else { return }
        let mid = result.points[result.points.count / 2]
        
        takeMapSnapshot(points: mid) { image in
            guard let imageData = image.jpegData(compressionQuality: .leastNormalMagnitude) else {
                NSLog("러닝 맵 스냅샷을 Data로 변환하는데 실패했습니다.")
                return
            }
            
            HistoryManager.shared.create(
                email: UserManager.shared.getEmail(),
                averageSpeed: result.averageSpeed, averagePace: result.averagePace, distance: result.distance,
                caloriesBurned: result.caloriesBurned, numberOfSteps: result.numberOfSteps,
                locations: result.points,
                startDate: result.startDate, endDate: result.endDate, mapSnapshot: imageData, completion: nil)
        }
    }
    
    private func popToHomeVC() {
        navigationController?.popToRootViewController(animated: false)
    }
    
    private func takeMapSnapshot(points: Point, completion: @escaping (UIImage) -> Void) {
        let options: MKMapSnapshotter.Options = MKMapSnapshotter.Options()
        options.size = CGSize(width: 100, height: 100)
        options.mapType = .standard
        options.showsBuildings = true
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        options.region = MKCoordinateRegion(center: points.toCoordinate(), span: span)
        let snapshotter = MKMapSnapshotter(
            options: options
        )
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                NSLog("러닝 맵 스냅샷 생성에 실패했습니다.")
                return
            }
            completion(snapshot.image)
        }
    }
}

extension ResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return runningStats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RunningStatCardCell.identifier, for: indexPath) as! RunningStatCardCell
        let runningStat = runningStats[indexPath.row]
        cell.configure(with: runningStat)
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
