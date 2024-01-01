//
//  RunningResultViewController.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/11/23.
//

import UIKit
import MapKit

class RunningResultViewController: UIViewController {
    
    var route: Route?
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        return sv
    }()
    
    private let resultMapView: MKMapView = {
        let mv = MKMapView()
        return mv
    }()
    
    // TODO: - collectionView로 그리드 표현하도록 수정
    private let runningResultView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let endButtonView: UIView = {
        let view = UIView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        buildMap()
        applyConstraints()
    }
    
    private func buildUI() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(resultMapView)
        stackView.addArrangedSubview(runningResultView)
        stackView.addArrangedSubview(endButtonView)
    }
    
    private func applyConstraints() {
        let stackViewConstraints = [
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        
        let resultMapViewConstraints = [
            resultMapView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.4),
        ]
        
        let runningResultViewConstraints = [
            runningResultView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.4),
        ]
        
        let endButtonViewConstraints = [
            endButtonView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.2),
        ]
        
        NSLayoutConstraint.activate(stackViewConstraints)
        NSLayoutConstraint.activate(resultMapViewConstraints)
        NSLayoutConstraint.activate(runningResultViewConstraints)
        NSLayoutConstraint.activate(endButtonViewConstraints)
    }
}

extension RunningResultViewController: MKMapViewDelegate {
    private func buildMap() {
        resultMapView.delegate = self
        route?.drawRouteOn(map: resultMapView)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKGradientPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 5
        renderer.strokeColor = .systemBlue
        return renderer
    }
}
