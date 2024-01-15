//
//  DrawbleMapView.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/9/24.
//

import Foundation
import MapKit
import SnapKit

enum MapViewDrawbleError: Error {
    case lackOfPointsToDrawRoute
    
    var description: String {
        switch self {
        case .lackOfPointsToDrawRoute:
            return "너무 적은 이동거리는 지도에 표시할 수 없습니다."
        }
    }
}

protocol MapViewDrawble {
    func drawRoute(points: [Point]) throws
    func drawPinAt(point: Point, title: String?)
}

extension MKMapView: MapViewDrawble {
    func drawRoute(points: [Point]) throws {
        let count = points.count
        
        if count < 3 {
            throw MapViewDrawbleError.lackOfPointsToDrawRoute
        }
        
        let line = MKPolyline(coordinates: points.map{ $0.toCoordinate() }, count: count)
        
        DispatchQueue.main.async { [weak self] in
            self?.addOverlay(line, level: .aboveRoads)
            let customEdgePadding: UIEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 20)
            self?.setVisibleMapRect(line.boundingMapRect, edgePadding: customEdgePadding, animated: false)
        }
    }
    
    func drawPinAt(point: Point, title: String?) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = point.toCoordinate()
        annotation.title = title
        self.addAnnotation(annotation)
    }
    
    func drawMessageOverlay(_ message: String) {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        self.addSubview(visualEffectView)
        
        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        
        visualEffectView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(self)
        }
        
        label.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
        }
    }
}
