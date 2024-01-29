//
//  HistoryTableViewCell.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/23/24.
//

import UIKit
import SnapKit
import MapKit

class HistoryTableViewCell: UITableViewCell {
    
    static let identifier = "HistoryTableViewCell"
    
    private let stackView = UIStackView()
    private let mapSnapshotView = UIImageView()
    private let labelStackView = UIStackView()
    private let dateLabel = UILabel()
    private let distanceLabel = UILabel()
    private let subStatView = UIView()
    private let durationLabel = UILabel()
    private let caloriesBurnedLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupStackView()
        setupMapSnapshotView()
        setupLabelStackView()
        setupDateLabel()
        setupDistanceLabel()
        setupSubStatView()
        setupDurationLabel()
        setupCaloriesBurnedLabel()
    }
    
    required init(coder: NSCoder) {
        fatalError("HistoryTableViewCell 생성 실패")
    }
    
    private func setupStackView() {
        contentView.addSubview(stackView)
        stackView.backgroundColor = .secondarySystemBackground
        stackView.layer.cornerRadius = 12
        stackView.clipsToBounds = true
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func setupMapSnapshotView() {
        stackView.addArrangedSubview(mapSnapshotView)
        mapSnapshotView.layer.cornerRadius = 8
        mapSnapshotView.clipsToBounds = true
        mapSnapshotView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    private func setupLabelStackView() {
        stackView.addArrangedSubview(labelStackView)
        labelStackView.axis = .vertical
        labelStackView.spacing = 8
        labelStackView.distribution = .fillEqually
        labelStackView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.7)
        }
    }
    
    private func setupDateLabel() {
        labelStackView.addArrangedSubview(dateLabel)
        dateLabel.font = UIFont.systemFont(ofSize: 15)
        dateLabel.textColor = .systemGray2
    }
    
    private func setupDistanceLabel() {
        labelStackView.addArrangedSubview(distanceLabel)
        distanceLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        distanceLabel.textColor = .black
    }
    
    private func setupSubStatView() {
        labelStackView.addArrangedSubview(subStatView)
    }
    
    private func setupDurationLabel() {
        subStatView.addSubview(durationLabel)
        durationLabel.font = UIFont.systemFont(ofSize: 15)
        durationLabel.textColor = .systemGray2
        durationLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
    
    private func setupCaloriesBurnedLabel() {
        subStatView.addSubview(caloriesBurnedLabel)
        caloriesBurnedLabel.font = UIFont.systemFont(ofSize: 15)
        caloriesBurnedLabel.textColor = .systemGray2
        caloriesBurnedLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(durationLabel.snp.trailing).offset(8)
        }
    }
    
    func configure(with history: History) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let dateString = dateFormatter.string(from: history.startDate)
        dateLabel.text = dateString
        distanceLabel.text = history.distance.formatDistance()
        caloriesBurnedLabel.text = history.caloriesBurned.formatCaloriesBurned()
        let duration = history.endDate - history.startDate
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        durationLabel.text = String(format: "%02d:%02d", minutes, seconds)
        mapSnapshotView.image = UIImage(data: history.mapSnapshot)
    }
}

extension HistoryTableViewCell: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKGradientPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 1
        renderer.strokeColor = .systemBlue
        return renderer
    }
}
